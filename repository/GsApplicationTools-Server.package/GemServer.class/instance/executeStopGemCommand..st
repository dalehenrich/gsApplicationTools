server specialization
executeStopGemCommand: port
  | commandLine performOnServerStatusArray |
  commandLine := self stopScriptPath , ' ' , self name , ' ' , port asString
    , ' "' , self exeConfPath , '"'.
  self performOnServer: commandLine