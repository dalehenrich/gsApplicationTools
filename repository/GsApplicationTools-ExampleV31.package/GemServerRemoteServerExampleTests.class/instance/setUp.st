running
setUp
  [ 
  super setUp.
  (GemServerRemoteServerExample register: self gemServerName) stopGems.
  (ObjectLogEntry trace: 'setup: stopGems') addToLog.
  GemServerRemoteTaskExample reset.
  System commitTransaction ]
    on: Error
    do: [ :ex | 
      Transcript
        cr;
        show: 'GemServerRemoteServerExampleTests>>setup';
        cr;
        show: ex description;
        cr;
        show: (GsProcess stackReportToLevel: 100).
      ex pass ]