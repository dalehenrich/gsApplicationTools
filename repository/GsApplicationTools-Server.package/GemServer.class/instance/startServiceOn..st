service instance-private
startServiceOn: port
  "does not return"

  GsFile gciLogServer: self name , ' Server started on port ' , port printString.
  (self serverClass on: port) start.
  [ true ] whileTrue: [ (Delay forSeconds: 10) wait ]