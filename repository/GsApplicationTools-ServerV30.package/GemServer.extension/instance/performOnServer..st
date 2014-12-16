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
        , ' failed with errno: '
        , (performOnServerStatusArray at: 5) printString , ' errMsg: '
        , (performOnServerStatusArray at: 4) asString.
      self error: message ].
  ^ performOnServerStatusArray at: 3