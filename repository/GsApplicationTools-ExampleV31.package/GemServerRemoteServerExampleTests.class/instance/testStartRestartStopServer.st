tests
testStartRestartStopServer
  "just start/restart/stop ... without an http client cannot do much else"

  "https://github.com/GsDevKit/gsApplicationTools/issues/19"

  | gemServer |
  gemServer := GemServer gemServerNamed: self gemServerName.
  gemServer tracing: true.
  gemServer scriptLogEvent: '---->testStartRestartStopServer' object: gemServer.
  [ 
  | portCount |
  self startGems: gemServer.
  (Delay forSeconds: 3) wait.
  portCount := self validatePidFile: gemServer shouldExist: true.
  self assert: portCount = gemServer defaultPortOrResourceNameList size.
  gemServer restartGems.
  (Delay forSeconds: 3) wait.
  self validatePidFile: gemServer shouldExist: true ]
    ensure: [ 
      self stopGems: gemServer.
      (Delay forSeconds: 3) wait.
      self validatePidFile: gemServer shouldExist: false ]