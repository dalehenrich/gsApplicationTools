server specialization
executeStartGemCommand: portOrResourceName
  | commandLine |
  commandLine := self startScriptPath , ' ' , self name , ' '
    , portOrResourceName asString , ' "' , self exeConfPath , '"'.
  self performOnServer: commandLine