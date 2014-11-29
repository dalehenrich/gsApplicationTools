server specialization
exeConfPath
  ^ (GsFile _expandEnvVariable: 'GEMSTONE_EXE_CONF' isClient: false)
    ifNil: [ GsFile _expandEnvVariable: '$HOME' isClient: false ]