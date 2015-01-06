service instance-server
basicServerOn: port
  "forked by caller"

  [ true ] whileTrue: [ self gemServer: [ self serviceLoop ] ]