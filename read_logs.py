#!/usr/bin/env python3

import argparse
import json
import sys
from datetime import datetime
from pathlib import Path


def main():
    parser = argparse.ArgumentParser(prog='OTel Log Parser')
    parser.add_argument(
        '-aa',
        '--all-attributes',
        action='store_true'
    )
    parser.add_argument(
        '-fa',
        '--filter-attributes',
        nargs='*',
    )
    parser.add_argument('log_file', nargs='?', type=Path)

    args = parser.parse_args()

    log_file: Path = args.log_file
    show_all_attributes: bool = args.all_attributes
    show_filter_attributes: list[str] = args.filter_attributes

    if log_file and not log_file.is_file():
        sys.exit('The file does not exist')

    if log_file is not None and sys.stdin.isatty() is False:
        sys.exit('Please just supply one log source')

    if sys.stdin.isatty() is True and log_file is None:
        sys.exit('You must supply a log source')

    if not sys.stdin.isatty():
        input_stream = sys.stdin
    else:
        if not log_file.is_file():
            sys.exit('The file does not exist')

        input_stream = log_file.open()

    for line in input_stream:
        try:
            otel_data = json.loads(line)
        except json.decoder.JSONDecodeError:
            # line already has a newline, so we set it to emptystring in print
            print(line, end='')
            continue

        occurred_at = datetime.fromtimestamp(otel_data['Timestamp'] / 1e9)

        logging_fragments: list[str] = [f'{occurred_at.strftime("%Y-%m-%d %H:%M:%S")}']
        if show_all_attributes:
            logging_fragments.append(', '.join([f'{key}: {value}' for key, value in otel_data['Attributes'].items()]))
        elif show_filter_attributes:
            logging_fragments.append(
                ', '.join(
                    [
                        f'{key}: {value}' for key, value in otel_data['Attributes'].items()
                        if key in show_filter_attributes
                    ],
                ),
            )
        logging_fragments.append(otel_data["Body"])

        print(' '.join(logging_fragments))


if __name__ == '__main__':
    main()
