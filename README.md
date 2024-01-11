# MobiData BW Integrationsplattform

**The [*MobiData BW*](https://mobidata-bw.de) *Integrationsplattform* (IPL) is an API platform aggregating various kinds of mobility data for [Baden-Württemberg](https://en.wikipedia.org/wiki/Baden-Württemberg).**

- By converting and harmonizing several underlying data sources, and then integrating them with each other, it spares consumers having to spent time on each city or region, allowing them to focus on their project.
- By providing individual APIs specifically tailored towards certain forms of mobility (e.g. sharing vehicles), it allows consumers to query & filter the data more easily.

Using [Docker Compose](https://docs.docker.com/compose/), this repo ties together and configures ("orchestrates") all of IPL's components, hence the name `ipl-orchestration`.

Most of these components are third-party projects, re-used in order to provide industry-standard APIs and to make long-term maintenance easier; Check the [*Compose Services* section](#compose-services) for more details.


## Installation

> ![NOTE]
> `ipl-orchestration` is intended to be deployed via [Ansible](https://docs.ansible.com/ansible/latest/), using the playbooks defined in [`ipl-ansible`](https://github.com/mobidata-bw/ipl-ansible), but it should also be usable standalone.

### Prerequisites

First, we have to install [Docker Desktop](https://docs.docker.com/desktop/); Follow the [official installation instructions](https://docs.docker.com/get-docker/). You also need [Docker Compose](https://docs.docker.com/compose/), which is usually bundled with Docker Desktop.

In addition, you need the following tools:
- [`make`](https://en.wikipedia.org/wiki/Make_(software))
