running
tearDown
  [ 
  | gemServer |
  super tearDown.
  (ObjectLogEntry trace: 'tearDown: stopGems') addToLog.
  gemServer := GemServerRegistry gemServerNamed: self gemServerName.
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