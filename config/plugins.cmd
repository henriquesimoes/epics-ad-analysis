# Configuration of plugins for the simulator
# It uses the following environment variable macros

# $(PREFIX)      Prefix for all records
# $(PORT)        The port name for the detector.
# $(QSIZE)       The queue size for all plugins.
# $(XSIZE)       The maximum image width; used to set the maximum size for row profiles in the NDPluginStats plugin and 1-D FFT
#                   profiles in NDPluginFFT.
# $(YSIZE)       The maximum image height; used to set the maximum size for column profiles in the NDPluginStats plugin
# $(NCHANS)      The maximum number of time series points in the NDPluginStats, NDPluginROIStats, and NDPluginAttribute plugins
# $(MAX_THREADS) The maximum number of threads for plugins which can run in multiple threads. Defaults to 5.

# Create an HDF5 file saving plugin
NDFileHDF5Configure("HDF5", $(QSIZE), 0, "$(PORT)", 0)
dbLoadRecords("NDFileHDF5.template", "P=$(PREFIX), R=HDF5:, PORT=HDF5, ADDR=0, TIMEOUT=1, XMLSIZE=2048, NDARRAY_PORT=$(PORT)")

# Create ROI plugin
NDROIConfigure("ROI", $(QSIZE), 0, "$(PORT)", 0, 0, 0, 0, 0, $(MAX_THREADS=5))
dbLoadRecords("NDROI.template", "P=$(PREFIX), R=ROI:, PORT=ROI, ADDR=0, TIMEOUT=1, NDARRAY_PORT=$(PORT)")

# Create ROIStat plugin
NDROIStatConfigure("ROISTAT", $(QSIZE), 0, "$(PORT)", 0, 1, 0, 0, 0, 0, $(MAX_THREADS=5))
dbLoadRecords("NDROIStat.template", "P=$(PREFIX), R=ROIStat:  , PORT=ROISTAT, ADDR=0, TIMEOUT=1, NDARRAY_PORT=$(PORT), NCHANS=$(NCHANS)")
dbLoadRecords("NDROIStatN.template", "P=$(PREFIX), R=ROIStat:1:, PORT=ROISTAT, ADDR=0, TIMEOUT=1, NCHANS=$(NCHANS)")

# Create a processing plugin
NDProcessConfigure("PROC", $(QSIZE), 0, "$(PORT)", 0, 0, 0)
dbLoadRecords("NDProcess.template", "P=$(PREFIX), R=Proc:, PORT=PROC, ADDR=0, TIMEOUT=1, NDARRAY_PORT=$(PORT)")

# Create statistics plugins
NDStatsConfigure("STATS", $(QSIZE), 0, "$(PORT)", 0, 0, 0, 0, 0, $(MAX_THREADS=5))
dbLoadRecords("NDStats.template", "P=$(PREFIX), R=Stats:, PORT=STATS, ADDR=0, TIMEOUT=1, HIST_SIZE=256, XSIZE=$(XSIZE), YSIZE=$(YSIZE), NCHANS=$(NCHANS), NDARRAY_PORT=$(PORT)")
NDTimeSeriesConfigure("STATS_TS", $(QSIZE), 0, "STATS", 1, 23)
dbLoadRecords("$(ADCORE)/db/NDTimeSeries.template", "P=$(PREFIX), R=Stats:TS:, PORT=STATS_TS, ADDR=0, TIMEOUT=1, NDARRAY_PORT=STATS, NDARRAY_ADDR=1, NCHANS=$(NCHANS), ENABLED=1")

# Create a transform plugin
NDTransformConfigure("TRANS", $(QSIZE), 0, "$(PORT)", 0, 0, 0, 0, 0, $(MAX_THREADS=5))
dbLoadRecords("NDTransform.template", "P=$(PREFIX), R=Trans:, PORT=TRANS, ADDR=0, TIMEOUT=1, NDARRAY_PORT=$(PORT)")

# Create an FFT plugin
NDFFTConfigure("FFT", $(QSIZE), 0, "$(PORT)", 0, 0, 0, 0, 0, 5)
dbLoadRecords("NDFFT.template", "P=$(PREFIX), R=FFT:, PORT=FFT, ADDR=0, TIMEOUT=1, NDARRAY_PORT=$(PORT), NAME=FFT, NCHANS=$(XSIZE)")
