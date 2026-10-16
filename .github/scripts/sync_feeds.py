#!/usr/bin/env python3
"""
sync_feeds.py

Compare etc/lamassu/feedproviders.yml with MobilityData/gbfs/systems.csv
and create PRs according to the rules described by the user. Only systems from
Baden-Württemberg are considered. A configurable city list is used to detect BW entries.

Behavior:
 - If present in both -> nothing
 - If only in feedproviders.yml and not in systems.csv:
     * If the system was removed from systems.csv recently (30 days) -> create PR to remove
       the system from feedproviders.yml (in this repo).
     * Otherwise -> create PR against MobilityData/gbfs to add the system (requires MOBILITYDATA_PAT)
 - If only in systems.csv -> create PR to add to feedproviders.yml (in this repo).

Notes:
 - The workflow will create PRs in this repo using the workflow's GITHUB_TOKEN.
 - To let the workflow create PRs in MobilityData/gbfs automatically, store a PAT
   with write access to that repo in the repository secret MOBILITYDATA_PAT.
 - The detection of "Baden-Württemberg" is done by matching city names (case-insensitive)
   from .github/feeds/bw_cities.txt against the systems.csv Name/Location/URL columns.

"""
import csv
import os
import subprocess
import sys
import tempfile
import time
from datetime import datetime, timedelta
from pathlib import Path

import requests
import yaml

# Config
REPO_PATH = Path('.')
FEEDPROVIDERS_PATH = REPO_PATH / 'etc' / 'lamassu' / 'feedproviders.yml'
SYSTEMS_CSV_URL = os.environ.get('SYSTEMS_CSV_URL', 'https://raw.githubusercontent.com/MobilityData/gbfs/refs/heads/master/systems.csv')
MOBILITYDATA_REPO = os.environ.get('MOBILITYDATA_REPO', 'MobilityData/gbfs')
MOBILITYDATA_PAT = os.environ.get('MOBILITYDATA_PAT')  # optional
GITHUB_TOKEN = os.environ.get('GITHUB_TOKEN')

# How far back to consider "recently removed"
RECENT_DAYS = int(os.environ.get('RECENT_DAYS', '30'))

# city list path
BW_CITIES_PATH = REPO_PATH / '.github' / 'scripts' / 'bw_cities.txt'

# Git remote template using token for pushing to this repo
GITHUB_REPO = os.environ.get('GITHUB_REPOSITORY', '')  # e.g. mobidata-bw/ipl-orchestration


def load_feedproviders(path):
    with open(path, 'r', encoding='utf-8') as f:
        data = yaml.safe_load(f)
    providers = data.get('lamassu', {}).get('providers', [])
    by_systemid = {p.get('systemId'): p for p in providers}
    return data, providers, by_systemid


def download_systems_csv(url):
    print(f'Downloading systems.csv from {url} ...')
    r = requests.get(url, timeout=30)
    r.raise_for_status()
    return r.text


def load_bw_cities(path):
    if not path.exists():
        print('BW cities file not found at', path)
        return []
    with open(path, 'r', encoding='utf-8') as f:
        return [line.strip() for line in f if line.strip() and not line.startswith('#')]


def parse_systems_csv(csv_text):
    rows = []
    reader = csv.DictReader(csv_text.splitlines())
    for r in reader:
        rows.append(r)
    return rows


def is_bw_row(row, bw_tokens):
    cc = (row.get('Country Code') or row.get('Country') or '').strip()
    if cc != 'DE' and cc != 'D':
        return False
    hay = ' '.join([row.get('Name',''), row.get('Location',''), row.get('URL',''), row.get('Auto-Discovery URL','')]).lower()
    for tok in bw_tokens:
        if tok.lower() in hay:
            return True
    return False


def filter_bw_systems(rows, bw_tokens):
    return [r for r in rows if is_bw_row(r, bw_tokens)]


def systems_by_id(rows):
    out = {}
    for r in rows:
        sid = r.get('System ID')
        if sid:
            out[sid] = r
    return out


def ensure_git_config():
    subprocess.run(['git', 'config', '--global', 'user.email', 'actions@github.com'], check=True)
    subprocess.run(['git', 'config', '--global', 'user.name', 'github-actions[bot]'], check=True)


def run(cmd, cwd=None, check=True, capture_output=False, env=None):
    print('> ' + ' '.join(cmd))
    return subprocess.run(cmd, cwd=cwd, check=check, capture_output=capture_output, env=env)


def branch_and_push_changes(branch_name, repo_remote_url, files_to_commit, commit_message):
    ensure_git_config()
    run(['git', 'checkout', '-b', branch_name])
    run(['git', 'add'] + files_to_commit)
    run(['git', 'commit', '-m', commit_message])
    run(['git', 'push', '--set-upstream', repo_remote_url, branch_name])


def create_pr_in_repo(owner_repo, head_branch, base='main', title=None, body=None, token=None):
    token = token or GITHUB_TOKEN
    if not token:
        print('No token available to create PR in', owner_repo)
        return None
    url = f'https://api.github.com/repos/{owner_repo}/pulls'
    payload = {'title': title or f'Automated feed sync: {head_branch}', 'head': head_branch, 'base': base, 'body': body or ''}
    headers = {'Authorization': f'token {token}', 'Accept': 'application/vnd.github+json'}
    r = requests.post(url, json=payload, headers=headers, timeout=30)
    if r.status_code >= 400:
        print('Failed to create PR:', r.status_code, r.text)
        return None
    pr = r.json()
    print('Created PR:', pr.get('html_url'))
    return pr


def system_recently_touched_in_mobilitydata(system_id, days=RECENT_DAYS):
    with tempfile.TemporaryDirectory() as td:
        td = Path(td)
        repo_url = f'https://github.com/{MOBILITYDATA_REPO}.git'
        print('Cloning MobilityData repo (shallow) to inspect history...')
        try:
            run(['git', 'clone', '--depth', '200', '--no-single-branch', repo_url, str(td)])
        except Exception as e:
            print('Failed to clone MobilityData/gbfs to inspect history:', e)
            return False
        target = td / 'systems.csv'
        if not target.exists():
            print('systems.csv not found in MobilityData/gbfs clone at systems.csv')
            return False
        try:
            out = subprocess.check_output(['git', 'log', '-S', system_id, '--pretty=format:%H|%ci', '--', 'systems.csv'], cwd=str(td), text=True)
            if not out.strip():
                return False
            for line in out.splitlines():
                parts = line.split('|')
                if len(parts) >= 2:
                    commit_date = parts[1].strip()
                    dt = datetime.strptime(commit_date, '%Y-%m-%d %H:%M:%S %z')
                    if dt > datetime.now(dt.tzinfo) - timedelta(days=days):
                        print(f'Found commit touching {system_id} at {dt} within {days} days')
                        return True
            return False
        except subprocess.CalledProcessError as e:
            print('git log failed:', e)
            return False


def remove_system_from_feedproviders(data, system_id):
    providers = data.get('lamassu', {}).get('providers', [])
    new_providers = [p for p in providers if p.get('systemId') != system_id]
    data['lamassu']['providers'] = new_providers
    return data


def add_system_to_feedproviders(data, system_row):
    providers = data.get('lamassu', {}).get('providers', [])
    sid = system_row.get('System ID')
    name = system_row.get('Name') or sid
    codespace = (sid.split('_')[0] if '_' in sid else sid).upper()
    url = system_row.get('Auto-Discovery URL') or system_row.get('URL') or ''
    versions = (system_row.get('Supported Versions') or '').split(';')
    version = None
    if versions:
        version = versions[-1].strip()
    provider = {
        'systemId': sid,
        'operatorId': f'{codespace}:Operator:{sid}',
        'operatorName': name,
        'codespace': codespace,
        'url': url,
        'language': 'de',
    }
    if version:
        provider['version'] = version
    providers.append(provider)
    data['lamassu']['providers'] = providers
    return data


def write_feedproviders_yaml(path, data):
    with open(path, 'w', encoding='utf-8') as f:
        yaml.dump(data, f, sort_keys=False, allow_unicode=True)


def make_branch_and_pr_in_this_repo(modified_paths, branch_suffix, title, body):
    repo = GITHUB_REPO
    if not repo:
        print('GITHUB_REPOSITORY not set; cannot push PR to this repo automatically.')
        print('Modified files:', modified_paths)
        return None
    token = GITHUB_TOKEN
    if not token:
        print('GITHUB_TOKEN not available; cannot push PR to this repo.')
        return None
    branch = f'sync/{branch_suffix}-{int(time.time())}'

    remote_url = f'https://x-access-token:{token}@github.com/{repo}.git'
    try:
        run(['git', 'remote', 'set-url', 'origin', remote_url])
    except Exception:
        pass
    try:
        branch_and_push_changes(branch, 'origin', modified_paths, title)
    except Exception as e:
        print('Error creating branch and pushing changes:', e)
        return None
    pr = create_pr_in_repo(repo, head_branch=branch, title=title, body=body, token=token)
    return pr


def add_system_to_mobilitydata_and_pr(system_row):
    if not MOBILITYDATA_PAT:
        print('No MOBILITYDATA_PAT provided; cannot create PR in MobilityData/gbfs automatically.')
        print('Please create a PR manually to add the following systems.csv row:')
        print(system_row)
        return None
    with tempfile.TemporaryDirectory() as td:
        td = Path(td)
        repo_url = f'https://x-access-token:{MOBILITYDATA_PAT}@github.com/{MOBILITYDATA_REPO}.git'
        print('Cloning MobilityData repo for PR creation...')
        run(['git', 'clone', repo_url, str(td)])
        branch = f'add-system-{system_row.get("System ID")}-{int(time.time())}'
        run(['git', 'checkout', '-b', branch], cwd=str(td))
        csv_path = td / 'systems.csv'
        if not csv_path.exists():
            print('Unexpected: systems.csv not found in cloned repo; aborting add-to-MobilityData step')
            return None
        with open(csv_path, 'r', encoding='utf-8') as f:
            header = f.readline().strip()
            cols = header.split(',')
        new_row = {k: '' for k in cols}
        new_row['Country Code'] = system_row.get('Country Code','DE')
        new_row['Name'] = system_row.get('Name','')
        new_row['Location'] = system_row.get('Location','')
        new_row['System ID'] = system_row.get('System ID','')
        new_row['URL'] = system_row.get('URL','')
        new_row['Auto-Discovery URL'] = system_row.get('Auto-Discovery URL','')
        new_row['Supported Versions'] = system_row.get('Supported Versions','')
        line = ','.join([new_row.get(c,'') for c in cols])
        with open(csv_path, 'a', encoding='utf-8') as f:
            f.write('\n' + line)
        run(['git', 'add', str(csv_path)], cwd=str(td))
        run(['git', 'commit', '-m', f'Add system {system_row.get("System ID")} (automated)'], cwd=str(td))
        run(['git', 'push', '--set-upstream', 'origin', branch], cwd=str(td))
        pr = create_pr_in_repo(MOBILITYDATA_REPO, head_branch=branch, base='main', title=f'Add system {system_row.get("System ID")}', body='Automated PR to add system (from mobidata-bw feed sync)', token=MOBILITYDATA_PAT)
        return pr


def main():
    if not FEEDPROVIDERS_PATH.exists():
        print('feedproviders.yml not found at', FEEDPROVIDERS_PATH)
        sys.exit(1)

    data, providers, fp_by_id = load_feedproviders(FEEDPROVIDERS_PATH)

    csv_text = download_systems_csv(SYSTEMS_CSV_URL)
    rows = parse_systems_csv(csv_text)

    bw_tokens = load_bw_cities(BW_CITIES_PATH)
    print('BW tokens:', bw_tokens[:10], '... (total', len(bw_tokens), ')')

    bw_rows = filter_bw_systems(rows, bw_tokens)
    print(f'Found {len(bw_rows)} BW rows in systems.csv')

    systems = systems_by_id(bw_rows)
    all_system_ids = set(systems_by_id(rows))
    fp_ids = set([k for k in fp_by_id.keys() if k])
    sys_ids = set(systems.keys())

    in_both = fp_ids & sys_ids
    present_outside_bw = (fp_ids & all_system_ids) - sys_ids
    only_in_feedproviders = fp_ids - all_system_ids
    only_in_systems = sys_ids - fp_ids

    print('in both:', len(in_both))
    print('present in systems.csv but outside BW:', len(present_outside_bw))
    print('not found in systems.csv:', len(only_in_feedproviders))
    print('only in systems.csv:', len(only_in_systems))

    for sid in sorted(present_outside_bw):
        print(f'\nSkipping {sid}: present in systems.csv but outside Baden-Württemberg')

    for sid in sorted(only_in_feedproviders):
        print('\nProcessing feedproviders-only system:', sid)
        recently = system_recently_touched_in_mobilitydata(sid, days=RECENT_DAYS)
        if recently:
            print(f'{sid} was touched recently in MobilityData/gbfs -> creating PR to remove from feedproviders.yml')
            modified_data = remove_system_from_feedproviders(data.copy(), sid)
            write_feedproviders_yaml(FEEDPROVIDERS_PATH, modified_data)
            pr = make_branch_and_pr_in_this_repo([str(FEEDPROVIDERS_PATH)], branch_suffix=f'remove-{sid}', title=f'Remove {sid} from feedproviders (sync)', body=f'Automated: remove {sid} because it was removed/changed in MobilityData/gbfs recently')
            if pr:
                print('PR created to remove', sid)
        else:
            print(f'{sid} not found in systems.csv and not recently removed -> propose adding to MobilityData/gbfs')
            entry = fp_by_id.get(sid)
            row = {
                'Country Code': 'DE',
                'Name': entry.get('operatorName') if entry else sid,
                'Location': '',
                'System ID': sid,
                'URL': entry.get('url') if entry else '',
                'Auto-Discovery URL': entry.get('url') if entry else '',
                'Supported Versions': entry.get('version','') if entry else ''
            }
            pr = add_system_to_mobilitydata_and_pr(row)
            if not pr:
                print('Could not create PR in MobilityData/gbfs automatically. Please open a PR there to add system:', sid)

    for sid in sorted(only_in_systems):
        print('\nProcessing systems-only system:', sid)
        system_row = systems.get(sid)
        if not system_row:
            continue
        print('Creating PR to add', sid, 'to feedproviders.yml')
        modified_data = add_system_to_feedproviders(data.copy(), system_row)
        write_feedproviders_yaml(FEEDPROVIDERS_PATH, modified_data)
        pr = make_branch_and_pr_in_this_repo([str(FEEDPROVIDERS_PATH)], branch_suffix=f'add-{sid}', title=f'Add {sid} to feedproviders (sync)', body='Automated: add system from MobilityData systems.csv')
        if pr:
            print('PR created to add', sid)

    print('\nDone')


if __name__ == '__main__':
    main()
