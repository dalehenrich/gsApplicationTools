server specialization
scriptPath
  "override as necessary"

  ^ (GsFile _expandEnvVariable: 'GEMSTONE_STONE_DIR' isClient: false)
    , '/tools/runSmalltalkServerGem '