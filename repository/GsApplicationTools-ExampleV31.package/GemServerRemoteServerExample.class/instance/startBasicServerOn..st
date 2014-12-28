service instance-server
startBasicServerOn: ignored
  "start server in current vm. expected to return."

  self
    doSimpleTransaction: [ 
      "prime the pump"
      currentQueueCounter := 0 ].
  self
    serverProcess:
      [ [ true ] whileTrue: [ self gemServer: [ self serviceLoop ] ] ] fork.
  self serverInstance: self	"the serverProcess is session-specific"