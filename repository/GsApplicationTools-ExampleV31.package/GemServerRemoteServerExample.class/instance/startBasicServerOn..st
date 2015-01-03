service instance-server
startBasicServerOn: ignored
  "start server in current vm. expected to return."

  self
    doTransaction: [ 
      "prime the pump"
      currentQueueCounter := 0 ].
  self
    basicServerProcess:
      [ [ true ] whileTrue: [ self gemServer: [ self serviceLoop ] ] ] fork.
  self serverInstance: self	"the serverProcess is session-specific"