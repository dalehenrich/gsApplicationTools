*gsapplicationtools-serverv30
performOnServer: commandLine
  | performOnServerStatusArray |
  performOnServerStatusArray := System _performOnServer: commandLine.
  self
    scriptLogEvent: 'performOnServer: ' , self name
    object:
      {commandLine.
      performOnServerStatusArray}.
  (performOnServerStatusArray at: 1) ~~ 0
    ifTrue: [ 
      | message |
      message := 'performOnServer: ' , commandLine printString
        , ' failed with result: ' , (performOnServerStatusArray at: 3) asString.
      Transcript
        cr;
        show: '---ERROR (';
        show: TimeStamp now printString;
        show: ')';
        cr;
        show: message.
      self error: message ]