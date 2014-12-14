server specialization
executeStopGemCommand: port
  | commandLine |
  commandLine := self stopScriptPath , ' ' , self name , ' ' , port asString
    , ' "' , self exeConfPath , '"'.
  self performOnServer: commandLine