server specialization
executeStartGemCommand: portOrResourceName
  | commandLine |
  commandLine := self startScriptPath , ' ' , self name , ' "'
    , portOrResourceName printString , '" "' , self exeConfPath , '"'.
  self performOnServer: commandLine