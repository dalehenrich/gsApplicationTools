service instance-server
startServerOn: port
  "start server in current vm. for gemstone, not expected to return."

  self startBasicServerOn: port.
  [ true ] whileTrue: [ (Delay forSeconds: 10) wait ]