server specialization
executeStartGemCommand: port
  | commandLine performOnServerStatusArray |
  commandLine := self startScriptPath , ' ' , self name , ' ' , port asString
    , ' "' , self exeConfPath , '"'.
  self performOnServer: commandLine