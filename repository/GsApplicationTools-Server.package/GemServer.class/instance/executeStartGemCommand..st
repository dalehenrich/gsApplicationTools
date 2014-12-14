server specialization
executeStartGemCommand: port
  | commandLine |
  commandLine := self startScriptPath , ' ' , self name , ' ' , port asString
    , ' "' , self exeConfPath , '"'.
  self performOnServer: commandLine