server specialization
performOnServer: commandLine
  "override as necessary"

  | performOnServerStatusArray |
  performOnServerStatusArray := System _performOnServer: commandLine.
  (performOnServerStatusArray at: 1) ~~ 0
    ifTrue: [ 
      | message |
      message := 'performOnServer: ' , commandLine printString
        , ' failed with result: '
        , (performOnServerStatusArray at: 3) asString printString.
      Transcript
        cr;
        show: '---ERROR (';
        show: TimeStamp now printString;
        show: ')';
        cr;
        show: message.
      self error: message ]