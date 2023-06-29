FROM ghcr.io/cnpem/lnls-debian-11-epics-7 as BUILD_STAGE

ENV PATH=$PATH:/opt/epics/base/bin/linux-x86_64

RUN apt update -y && \
    apt install -y --no-install-recommends \
        procps \
        gdb

RUN make -C /opt/epics/modules/areaDetector/ADSimDetector/iocs/simDetectorIOC

WORKDIR /opt/epics/modules/areaDetector/ADSimDetector/iocs/simDetectorIOC/iocBoot/iocSimDetector

COPY config/*cmd .

CMD make -C /opt/epics/modules/areaDetector/ADCore && \
    (camonitor SIM:Stats:ExecutionTime_RBV > /tmp/stats.time &) && \
    sleep 5 && \
    ./st.cmd
