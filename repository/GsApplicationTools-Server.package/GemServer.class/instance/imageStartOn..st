service instance-image
imageStartOn: port
  "Run in the calling vm. Skip all of the remote vm decorations"

  self startServiceOn: port	"does not return"