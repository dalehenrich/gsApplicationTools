server specialization
exeConfPath
  ^ (GsFile _expandEnvVariable: 'GEMSTONE_EXE_CONF' isClient: false)
    ifNil: [ 
      "Use the defualt gem.conf file"
      '' ]