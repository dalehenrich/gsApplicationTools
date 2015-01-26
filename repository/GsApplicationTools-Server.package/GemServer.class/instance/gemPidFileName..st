service instance-private
gemPidFileName: portOrResourceName
  "must match bin/stopGemServerGem script"

  | logDir |
  logDir := (GsFile _expandEnvVariable: 'GEMSTONE_LOGDIR' isClient: false)
    ifNil: [ '/opt/gemstone/log' ].
  ^ logDir , '/' , self name , '_server-' , portOrResourceName asString , '.pid'