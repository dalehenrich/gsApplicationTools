server specialization
pidDirPath
  ^ (GsFile _expandEnvVariable: '$GEMSTONE_PID_DIR' isClient: false)
    ifNil: [ self defaultPidDirPath ]