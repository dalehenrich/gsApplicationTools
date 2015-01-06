service instance-server
startBasicServerOn: ignored
  "start server in current vm. expected to return."

  self
    doTransaction: [ 
      "prime the pump"
      currentQueueCounter := 0 ].
  super startBasicServerOn: ignored