FROM ghcr.io/cnpem/lnls-debian-11-epics-7 as BUILD_STAGE

ENV PATH=$PATH:/opt/epics/base/bin/linux-x86_64

RUN apt update -y && \
    apt install -y --no-install-recommends \
        procps \
        gdb

RUN make -C /opt/epics/modules/areaDetector/ADSimDetector/iocs/simDetectorIOC

WORKDIR /opt/epics/modules/areaDetector/ADSimDetector/iocs/simDetectorIOC/iocBoot/iocSimDetector

RUN ln -s envPaths envPaths.linux && \
    sed -e "s|commonPlugins.cmd|EXAMPLE_commonPlugins.cmd|" \
        -i st_base.cmd

CMD make -C /opt/epics/modules/areaDetector/ADCore && \
    ./start_epics
