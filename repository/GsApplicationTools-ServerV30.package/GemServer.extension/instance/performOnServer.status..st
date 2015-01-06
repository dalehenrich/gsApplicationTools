*gsapplicationtools-serverv30
performOnServer: commandLine status: statusBlock
  | performOnServerStatusArray |
  performOnServerStatusArray := System _performOnServer: commandLine.
  self
    scriptLogEvent: 'performOnServer: ' , self name , ' :: ' , commandLine
    object:
      {commandLine.
      performOnServerStatusArray}.
  ^ statusBlock value: performOnServerStatusArray