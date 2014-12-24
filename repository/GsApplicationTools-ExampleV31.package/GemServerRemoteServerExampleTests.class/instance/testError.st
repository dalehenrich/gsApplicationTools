tests
testError
  | gemServer client completed |
  gemServer := GemServerRegistry gemServerNamed: self gemServerName.
  gemServer tracing: false.
  gemServer scriptLogEvent: '---->testError' object: gemServer.
  client := GemServerRemoteClientExample new.
  [ 
  | task |
  self startGems: gemServer.
  task := client scheduleErrorTask.
  completed := self waitForTasks: {task} for: client trace: gemServer tracing ]
    ensure: [ self stopGems: gemServer ]