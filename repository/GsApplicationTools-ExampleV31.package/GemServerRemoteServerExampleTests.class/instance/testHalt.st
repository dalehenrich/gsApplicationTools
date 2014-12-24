tests
testHalt
  | gemServer client completed |
  gemServer := GemServerRegistry gemServerNamed: self gemServerName.
  gemServer tracing: true.
  gemServer scriptLogEvent: '---->testHalt' object: gemServer.
  client := GemServerRemoteClientExample new.
  [ 
  | task |
  self startGems: gemServer.
  task := client scheduleHaltTask.
  completed := self waitForTasks: {task} for: client ]
    ensure: [ self stopGems: gemServer ]