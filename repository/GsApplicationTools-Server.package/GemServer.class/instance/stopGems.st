service instance-control
stopGems
  self logControlEvent: 'Stop Gems: ' , self name.
  self portOrResourceNameList
    do: [ :portOrResourceName | self executeStopGemCommand: portOrResourceName ]