service instance-script
scriptStartServiceOn: portOrResourceName
  "called from shell script"

  self
    scriptServicePrologOn: portOrResourceName;
    startServerOn: portOrResourceName	"does not return"