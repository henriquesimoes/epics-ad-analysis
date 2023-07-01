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

## Profiling a code

For profiling you should first start Docker service and wait until the patched
module is compiled (for instance, by monitoring the logs).

```bash
docker compose up -d
docker compose logs --follow simulator
```

Once the IOC started running, we can get the process ID (PID) of the IOC by running:

```bash
docker compose exec simulator bash -c \
      "ps -u root | grep simDetector"
```

Based on the PID, we can now attach Linux Perf to this process and collect the
statistics in the host operating system with superuser permissions.
