tests
testSimple
  [ 
  | gemServer client completed |
  gemServer := GemServerRegistry gemServerNamed: self gemServerName.
  gemServer tracing: false.
  gemServer scriptLogEvent: '---->testSimple' object: gemServer.
  client := GemServerRemoteClientExample new.
  [ 
  | task |
  self startGems: gemServer.
  task := client scheduleSimpleTask.
  completed := self waitForTasks: {task} for: client trace: gemServer tracing ]
    ensure: [ self stopGems: gemServer ] ]
    on: Error
    do: [ :ex | 
      Transcript
        cr;
        show: 'GemServerRemoteServerExampleTests>>testSimple';
        cr;
        show: ex description;
        cr;
        show: (GsProcess stackReportToLevel: 100) ]