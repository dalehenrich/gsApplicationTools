server specialization
executeStopGemCommand: portOrResourceName
  | commandLine |
  commandLine := self stopScriptPath , ' ' , self name , ' '
    , portOrResourceName asString , ' "' , self exeConfPath , '"'.
  self performOnServer: commandLine