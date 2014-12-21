*gsapplicationtools-serverv30
performOnServer: commandLine status: statusBlock
  | performOnServerStatusArray |
  performOnServerStatusArray := System _performOnServer: commandLine.
  self
    scriptLogEvent: 'performOnServer: ' , self name
    object:
      {commandLine.
      performOnServerStatusArray}.
  ^ statusBlock value: performOnServerStatusArray