control
startOn: port
  (self serverClass on: port) start.
  [ true ] whileTrue: [ (Delay forSeconds: 10) wait ]