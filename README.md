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

Refer to the [*Controlling Docker Compose Services* section](#controlling-docker-compose-services) for details on how to start the IPL services.


## Controlling Docker Compose Services

Because IPL is basically a set of [Docker Compose](https://docs.docker.com/compose/) services, it is also operated this way.

> [!IMPORTANT]
> The following code snippets assume that you have either defined all config values necessary for your local installation in `.env.local` (recommended, check the installation instructions), or `export`ed them as environment variables.

There is a [Makefile](https://en.wikipedia.org/wiki/Make_(software)#Makefiles) which defines shortcuts for useful Compose commands; It assumes that you're using `.env.local`. The equivalent shortcut is shown beneath each “manual” `docker compose` command.

### Start services

If you want to start *all* services and keep them running in your current shell (in the foreground), use `docker compose up`:

```bash
docker compose --env-file .env --env-file .env.local up
# or use the shortcut:
make docker-up
```

Instead, you can also start an *individual* service (and the services it depends on), or multiple individual services:

```bash
docker compose --env-file .env --env-file .env.local up lamassu redis
# or use the shortcut:
make docker-up SERVICE="lamassu redis"
```

> [!NOTE]
> It often makes sense to start all services of one "domain" together because often they rely on each other. For example, if you want to work with the ParkAPI API (`park-api-flask`), we recommend starting all ParkAPI services (`park-api-flask`, `park-api-worker`, etc.).

If you want to run all services in a detached mode (a.k.a. as daemons), use the `--detatch`/`-d` option. This way, you can close you shell session, and they will keep running.

```bash
docker compose --env-file .env --env-file .env.local up --detach
# or use the shortcut:
make docker-up-detached
```

Of course, you can also run *individual* services in detached mode:

```bash
docker compose --env-file .env --enf-file .env.local up --detach redis
# or use the shortcut:
make docker-up-detached SERVICE="redis"
```

### Update and restart services

You can pull the latest Docker images (for each service from its respective registry):

```bash
docker compose --env-file .env --env-file .env.local pull
# or use the shortcut:
make docker-pull
```

As with `docker compose up` (see above), you can also pull *individual* services’ images:

```bash
docker compose --env-file .env --env-file .env.local pull redis
# or use the shortcut:
make docker-pull SERVICE="redis"
```

To re-run all services with these newly pulled images, use `docker compose down` & `docker compose up` (optionally with `--detached`). Again, if you don’t explicitly specify services, it will restart *all*:

```bash
docker compose --env-file .env --env-file .env.local down
docker compose --env-file .env --env-file .env.local up --detached
# or use the shortcuts:
make docker-down
make docker-up-detached
```

> [!WARNING]
> `docker compose restart` *does not* take changes to `.env` or `.env.local` into account! It merely restarts the services' containers with the environment variables as when they were originally started. To restart all services with modified/new environment variables, use `down` & `up`, as illustrated above. This should be your default workflow instead.


## Architecture

[`docker-compose.yml`](docker-compose.yml) is the core of `ipl-orchestration`; It defines, configures and connects [Compose](https://docs.docker.com/compose/) services.

Most important and/or opinionated (read: MobiData-BW-specific) configuration parameters are abstracted into [Compose variables](https://docs.docker.com/compose/environment-variables/) which are defined in `.env` and `.env.local`.

The subdirectories mimic the a [typical Unix filesystem structure](https://en.wikipedia.org/wiki/Filesystem_Hierarchy_Standard):

- `etc` contains config files with whatever configuration is *not* passed into services as environment variables. These config files are mounted into the respective containers.
- `bin` contains some helper commands used to manage the running system, e.g. for reloading the configuration of a service. Most of them are mounted into the respective containers.
- `var` mostly contains data that services create during runtime: downloaded/stored data, various logs files, lockfiles, etc. Most of `var` is Git-ignored; A notable exception is `var/www`, which contains static datasets served by the `caddy` service (see below).

### Port Usage and public HTTP paths

`ipl-orchestration` uses [Docker's bridge networking](https://docs.docker.com/network/network-tutorial-standalone/). We also make most services accessible to the outside world through our ingress/reverse proxy service (see `ingress` below).

This means that each Compose service that exposes a port has
- a port on the container's IP address (*container port*);
- a port on the host's IP address (*host port*);
- an HTTP path on the ingress (*ingress path*), if configured.

### Compose Services

The following table lists all IPL components and their respective Docker Compose services.

| component & functionality                                                           | Compose service      | permanently running? | host port | public HTTP path  | notes |
|-------------------------------------------------------------------------------------|----------------------|----------------------|----------:|--------------------|-------|
| HTTP ingress/reverse proxy ([Traefik Proxy](https://doc.traefik.io/traefik/))       | `traefik`            | ✔︎                    | 8080      | *-*                | exposes all other services via HTTP |
| HTTP ingress/reverse proxy: admin UI                                                | `traefik`            | ✔︎                    | 8081      | *-*                | allows inspecting Traefik's operating state |
| [GeoServer](https://geoserver.org)                                                  | `geoserver`          | ✔︎                    | 8600      | `/geoserver`       | serves geospatial data sources via WMS, WFS, WMTS, etc. |
| [OCPDB](https://github.com/binary-butterfly/ocpdb): API                             | `ocpdb-flask`        | ✔︎                    | 7000      | `/ocpdb`           | aggregates charge point data sources |
| OCPDB: background worker                                                            | `ocpdb-worker`       | ✔︎                    | *-*       | *-*                | fetches & imports 3rd-party data |
| OCPDB: initialization script                                                        | `ocpdb-init`         |                      | *-*       | *-*                | runs once on startup |
| OCPDB: database ([PostgreSQL](https://www.postgresql.org))                          | `ocpdb-db`           | ✔︎                    | *-*       | *-*                |
| OCPDB: task/message queue ([RabbitMQ](https://www.rabbitmq.com))                    | `ocpdb-rabbitmq`     | ✔︎                    | *-*       | *-*                | |
| [ParkApi](https://github.com/ParkenDD/park-api-v3): API                             | `park-api-flask`     | ✔︎                    | 7500      | `/park-api`        | aggregates parking lot data sources |
| ParkAPI: background worker                                                          | `park-api-worker`    | ✔︎                    | *-*       | *-*                | fetches & imports 3rd-party data |
| ParkAPI: initialization script                                                      | `park-api-init`      |                      | *-*       | *-*                | runs once on startup |
| ParkAPI: database ([PostgreSQL](https://www.postgresql.org))                        | `park-api-db`        | ✔︎                    | *-*       | *-*                |
| ParkAPI: task/message queue ([RabbitMQ](https://www.rabbitmq.com))                  | `park-api-rabbitmq`  | ✔︎                    | *-*       | *-*                | |
| ParkAPI: heartbeat                                                                  | `park-api-heartbeat` | ✔︎                    | *-*       | *-*                | |
| GBFS: [Lamassu](https://github.com/entur/lamassu)                                   | `lamassu`            | ✔︎                    | 8500      | `/sharing`         | aggregates [GBFS](https://gbfs.org) vehicle sharing data sources |
| GBFS: Lamassu (admin UI)                                                            | `lamassu`            | ✔︎                    | 9002      | *-*                | allows inspecting Lamassu's operating state |
| GBFS: Lamassu database ([Redis](https://redis.io))                                  | `redis`              | ✔︎                    | *-*       | *-*                |
| [Dagster](https://docs.dagster.io/getting-started): task runner                     | `dagster-pipeline`   | ✔︎                    | *-*       | *-*                | runs (custom Python) tasks, collects their logs |
| Dagster: task scheduler                                                             | `dagster-daemon`     | ✔︎                    | *-*       | *-*                | orchestrates [DAGs](https://en.wikipedia.org/wiki/Directed_acyclic_graph) of tasks |
| Dagster: UI                                                                         | `dagster-dagit`      | ✔︎                    | 3000      | *-*                | shows logs & results of the scripts |
| Dagster: database ([PostgreSQL](https://www.postgresql.org))                        | `dagster-postgresql` | ✔︎                    | *-*       | *-*                |
| [IPL Proxy](https://github.com/mobidata-bw/ipl-proxy)                               | `transformer-proxy`  | ✔︎                    | 8400      | *-*                | on-the-fly patching of HTTP resources from 3rd parties; used by OCPDB, x2gbfs, etc. |
| GBFS/RadVIS: database ([PostgreSQL](https://www.postgresql.org))                    | `ipl-db`             | ✔︎                    | 5432      | *-*                | stores fetched GBFS & RadVIS data |
| GTFS: API ([PostgREST](https://postgrest.org/))                                     | `gtfs-api`           | ✔︎                    | 4000      | `/gtfs`            | serves [GTFS](https://gtfs.org/schedule/) data as an API |
| GTFS: documentation ([Stoplight Elements](https://github.com/stoplightio/elements)) | `gtfs-swagger-ui`    | ✔︎                    | 4001      | `/docs/gtfs`       | UI documenting the GTFS API |
| GTFS: importer ([`postgis-gtfs-importer`](https://github.com/mobidata-bw/postgis-gtfs-importer)) | `gtfs-importer` |              | *-*       | *-*                | downloads, cleans & imports GTFS into the database; started by a Dagster task |
| GTFS: database ([PostgreSQL](https://www.postgresql.org))                           | `gtfs-db`            | ✔︎                    | *-*       | *-*                | stores imported GTFS data |
| database proxy ([pgbouncer](https://www.pgbouncer.org))                             | `pgbouncer`          | ✔︎                    | 6432      | *-*                | proxies services' connections to databases (`dagster-postgresql`, `gtfs-db`, etc.) |
| static data: web server ([Caddy](https://caddyserver.com))                          | `caddy`              | ✔︎                    | 6999      | `/datasets`        | serves static datasets |
| meta files: web server ([Caddy](https://caddyserver.com))                           | `well-known-uris`    | ✔︎                    | 6998      | `/.well-known`, `/robots.txt`, `/favicon.ico` | miscellaneous files, not datasets |
| ingress: requests log importer ([GoAccess](https://goaccess.io))                    | `goaccess`           |                      | *-*       | *-*                | computes request statistics from the ingress requests log; started manually/externally |
| ingress: requests statistics                                                        | `caddy`              | ✔︎                    | 8082      | *-*                | serves the Traefik request statistics |

todo: explain monitoring
