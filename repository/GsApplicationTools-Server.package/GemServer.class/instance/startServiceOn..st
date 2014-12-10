service instance-private
startServiceOn: port
  "does not return"

  GsFile gciLogServer: self name , ' Server started on port ' , port printString.
  self startServerOn: port	"for GemStone, startServerOn: is not expected to return"