server specialization
scriptBinDirPath
  ^ (GsFile _expandEnvVariable: 'GEMSTONE_STONE_SCRIPT_DIR' isClient: false)
    ifNil: [ self defaultScriptBinDirPath ]