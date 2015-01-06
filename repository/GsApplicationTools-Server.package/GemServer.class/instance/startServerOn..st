service instance-server
startServerOn: portOrNil
  "start server in current vm. Not expected to return."

  self startBasicServerOn: portOrNil.
  [ true ] whileTrue: [ (Delay forSeconds: 10) wait ]