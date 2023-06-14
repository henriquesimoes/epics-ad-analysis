#!../../bin/linux-x86_64/simDetectorApp

< envPaths

errlogInit(20000)
asynSetMinTimerPeriod(0.001)

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

# Create a standard arrays plugin, set it to get data from simulator driver.
NDStdArraysConfigure("Image1", 20, 0, "$(PORT)", 0, 0, 0, 0, 0, 5)

# This creates a waveform large enough for 1024 x 1024 x 3 (e.g. RGB color) arrays.
# This waveform only allows transporting 8-bit images
dbLoadRecords("NDStdArrays.template", "P=$(PREFIX), R=Image1:, PORT=Image1, ADDR=0, TIMEOUT=1, NDARRAY_PORT=$(PORT), TYPE=Int8, FTVL=UCHAR, NELEMENTS=3145728")

# Load all other plugins using plugins
< plugins.cmd

# Create a standard arrays plugin, set it to get data from FFT plugin.
NDStdArraysConfigure("Image2", 3, 0, "FFT", 0)
# This waveform allows transporting 64-bit images, so it can handle any detector data type at the expense of more memory and bandwidth
dbLoadRecords("NDStdArrays.template", "P=$(PREFIX), R=Image2:, PORT=Image2, ADDR=0, TIMEOUT=1, NDARRAY_PORT=FFT, TYPE=Float64, FTVL=DOUBLE, NELEMENTS=3145728")

# Enable asyn logging to stdout
asynSetTraceMask("$(PORT)", 0, ERROR | WARNING)

iocInit()
