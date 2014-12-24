tests
testBreakpoint
  | gemServer client completed |
  gemServer := GemServerRegistry gemServerNamed: self gemServerName.
  gemServer tracing: false.
  gemServer scriptLogEvent: '---->testBreakpoint' object: gemServer.
  client := GemServerRemoteClientExample new.
  [ 
  | task |
  self startGems: gemServer.
  task := client scheduleBreakpointTask.
  completed := self waitForTasks: {task} for: client ]
    ensure: [ self stopGems: gemServer ]