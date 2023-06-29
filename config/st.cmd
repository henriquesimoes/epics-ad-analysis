#!../../bin/linux-x86_64/simDetectorApp

< envPaths

dbLoadDatabase("$(TOP)/dbd/simDetectorApp.dbd")
simDetectorApp_registerRecordDeviceDriver(pdbbase) 

# Prefix for all records
epicsEnvSet("PREFIX", "SIM:")

# The port name for the detector
epicsEnvSet("PORT", "SIM")

# The queue size for all plugins
epicsEnvSet("QSIZE", "20")
# The maximum image width; used to set the maximum size for this driver and for row profiles in the NDPluginStats plugin
epicsEnvSet("XSIZE", "1024")
# The maximum image height; used to set the maximum size for this driver and for column profiles in the NDPluginStats plugin
epicsEnvSet("YSIZE", "1024")
# The maximum number of time series points in the NDPluginStats plugin
epicsEnvSet("NCHANS", "2048")

# The maximum number of threads for plugins which can run in multiple threads
epicsEnvSet("MAX_THREADS", "8")

# The search path for database files
epicsEnvSet("EPICS_DB_INCLUDE_PATH", "$(ADCORE)/db")

# Configure EPICS to automatically determine the buffer size
# to transfer the images
epicsEnvSet("EPICS_CA_AUTO_ARRAY_BYTES", "YES")

# Create a simDetector driver
simDetectorConfig("$(PORT)", $(XSIZE), $(YSIZE), 1, 0, 0)
dbLoadRecords("$(ADSIMDETECTOR)/db/simDetector.template", "P=$(PREFIX), R=Cam:, PORT=$(PORT), ADDR=0, TIMEOUT=1")

# Load plugins
< plugins.cmd

# Enable asyn logging to stdout
asynSetTraceMask("$(PORT)", 0, ERROR | WARNING)

iocInit()

dbpf $(PREFIX)Cam:AcquireTime 0.001
dbpf $(PREFIX)Cam:AcquirePeriod 0.005
dbpf $(PREFIX)Cam:ImageMode "Continuous"
dbpf $(PREFIX)Cam:ArrayCallbacks 1

dbpf $(PREFIX)Stats:NDArrayPort $(PORT)
dbpf $(PREFIX)Stats:EnableCallbacks 1
dbpf $(PREFIX)Stats:ComputeStatistics 1
dbpf $(PREFIX)Stats:ComputeCentroid 1
dbpf $(PREFIX)Stats:ComputeProfiles 1
dbpf $(PREFIX)Stats:ComputeHistogram 1

dbpf $(PREFIX)Cam:Acquire 1
