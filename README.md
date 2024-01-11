# MobiData BW Integrationsplattform

**The [*MobiData BW*](https://mobidata-bw.de) *Integrationsplattform* (IPL) is an API platform aggregating various kinds of mobility data for [Baden-Württemberg](https://en.wikipedia.org/wiki/Baden-Württemberg).**

- By converting and harmonizing several underlying data sources, and then integrating them with each other, it spares consumers having to spent time on each city or region, allowing them to focus on their project.
- By providing individual APIs specifically tailored towards certain forms of mobility (e.g. sharing vehicles), it allows consumers to query & filter the data more easily.

Using [Docker Compose](https://docs.docker.com/compose/), this repo ties together and configures ("orchestrates") all of IPL's components, hence the name `ipl-orchestration`.

Most of these components are third-party projects, re-used in order to provide industry-standard APIs and to make long-term maintenance easier; Check the [*Compose Services* section](#compose-services) for more details.


## Installation

> ![IMPORTANT]
> `ipl-orchestration` is intended to be deployed via [Ansible](https://docs.ansible.com/ansible/latest/), using the playbooks defined in [`ipl-ansible`](https://github.com/mobidata-bw/ipl-ansible), but it should also be usable "standalone". The following steps explain how to set it up manually.

### Prerequisites

First, we have to install [Docker Desktop](https://docs.docker.com/desktop/); Follow the [official installation instructions](https://docs.docker.com/get-docker/). You also need [Docker Compose](https://docs.docker.com/compose/), which is usually bundled with Docker Desktop.

<details>
<summary>Docker installation instructions for Debian/Ubuntu</summary>

> ![WARNING]
> These instructions may become outdated, please check the official Docker documentation.

Because we want to use the *latest* Docker packages, we set up the official package sources by Docker Inc. instead of using the built-in system sources.

```bash
# configure the Docker Inc. package sources
curl -fsSL 'https://download.docker.com/linux/ubuntu/gpg' | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg
echo "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
# update the list of available packages
apt update
# install Docker (Desktop)
apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```
</details>

In addition, you need the following tools:
- [`make`](https://en.wikipedia.org/wiki/Make_(software))

### Git Repository

Now that we have installed the prerequisites, let's clone the [`ipl-orchestration` repository (repo)](https://github.com/mobidata-bw/ipl-orchestration); It defines all [Compose services](https://docs.docker.com/compose/features-uses/) that make up IPL.

To mimic the [Ansible deployment](https://github.com/mobidata-bw/ipl-ansible), we clone into `/srv/docker-unmanaged/ipl`.

```bash
# Clone the Git repository.
mkdir -p /srv/docker-unmanaged/ipl
cd /srv/docker-unmanaged/ipl
git clone https://github.com/mobidata-bw/ipl-orchestration.git .
```

### `.env.local` file

> [!NOTE]
> Most IPL services will run as-is with their default configuration specified in the `.env` file.
> However, some services need customization to your local installation using an additional `.env.local` file that partially overrides `.env` and that is not checked into Git version control.

```bash
# create .env.local file from .env.local.example template
cp .env.local.example .env.local
# adapt .env.local now to your environment
```

- You should configure (properly generated) random passwords for all components that need one (e.g. the PostgreSQL DBs) instead of using the default ones!
- You must enter valid credentials to various third-party APIs (e.g. `$LAMASSU_TIER_USER`) for the respective services to work.
- You may want to adapt variables like `$*_BASE_URL` to your setup.

### Pull Docker Images

Make sure you have access to the [Docker images hosted in the `mobidata-bw` GitHub orginization]([GitHub Container Registry (GHCR a.k.a. `ghcr.io`)](https://github.com/orgs/mobidata-bw/packages)) by pulling them.

*Note:* Because running Docker Compose with *both* `.env` & `.env.local` is tedious, [the Makefile](Makefile) defines shortcuts for common `docker compose` commands, `make docker-pull` in this case.

```bash
docker compose --env-file .env --env-file .env.local pull
# or use a convenient shortcut for the command above:
make docker-pull
```

### Done

Your installation should now be ready!
