service instance-private
gemPidFileName: port
  "must match bin/stopGemServerGem script"

  ^ (GsFile _expandEnvVariable: 'GEMSTONE_LOGDIR' isClient: false) , '/'
    , self name , '_server-' , port asString , '.pid'