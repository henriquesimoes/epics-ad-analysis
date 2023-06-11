# Container Environment for Analyzing Area Detector

This repository contains a setup for experimenting changes to Area Detector
modules within a containerized enviroment aiming at analyzing performance. As
of now, only the `ADCore` module is configured to be changed.

## How it works

It uses a general build from LNLS Sirius which contains binaries from the
latest version of the EPICS modules in a containerized enviroment and runs the
Area Detector simulator `ADSimDetector`. For using the changed source code of
the submodules, volumes are mounted on top of the LNLS's compiled version and
recompiled at container runtime based on this repository submodules. Thus, any
changes made in the submodules will affect the next container runtime.

## How to use it

First, make your changes to the submodule in this repository. They don't need
to be commited to be tested inside the container. Having them in the working
directory suffices. To make sure your submodule is up-to-date, run

```bash
git submodule update --init --remote
```

Then, to execute the changes in the simulator, make sure you have [Docker
Engine](https://docs.docker.com/engine) and [Docker
Compose](https://docs.docker.com/compose), and issue

```bash
sudo docker compose up -d
```

This will launch the IOC inside the container and detach from it. Now, you can
access the container environment with

```bash
sudo docker compose exec simulator bash
```
