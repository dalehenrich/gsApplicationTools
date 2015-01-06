service instance-script
scriptStartServiceOn: portOrNil
  "called from shell script"

  self
    scriptServicePrologOn: portOrNil;
    startServerOn: portOrNil	"does not return"