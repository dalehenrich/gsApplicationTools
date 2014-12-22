service instance-private
startServiceOn: port
  "does not return"

  Transcript
    cr;
    show: self name , ' Server started on port ' , port printString.
  self startServerOn: port	"for GemStone, startServerOn: is not expected to return"