server specialization
executeStartGemCommand: port
  | commandLine performOnServerStatusArray |
  commandLine := self scriptPath , ' ' , self name , ' ' , port asString , ' "'
    , self exeConfPath , '"'.
  self performOnServer: commandLine