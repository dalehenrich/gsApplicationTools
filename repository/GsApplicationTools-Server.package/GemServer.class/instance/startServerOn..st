service instance-server
startServerOn: portOrResourceName
  "start server in current vm. Not expected to return."

  self startBasicServerOn: portOrResourceName.
  [ true ] whileTrue: [ (Delay forSeconds: 10) wait ]