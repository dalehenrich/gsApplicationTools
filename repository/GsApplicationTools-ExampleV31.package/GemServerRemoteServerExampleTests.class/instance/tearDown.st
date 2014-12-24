running
tearDown
  [ 
  | gemServer |
  gemServer := GemServerRegistry gemServerNamed: self gemServerName.
  super tearDown.
  (ObjectLogEntry trace: 'tearDown: stopGems') addToLog.
  gemServer
    doCommitTransaction;
    stopGems ]
    on: Error
    do: [ :ex | 
      Transcript
        cr;
        show: 'GemServerRemoteServerExampleTests>>tearDown';
        cr;
        show: ex description;
        cr;
        show: (GsProcess stackReportToLevel: 100).
      ex pass ]