service instance-private
gemPidFileName: portOrResourceName
  "must match bin/stopGemServerGem script"

  ^ (GsFile _expandEnvVariable: 'GEMSTONE_LOGDIR' isClient: false) , '/'
    , self name , '_server-' , portOrResourceName asString , '.pid'