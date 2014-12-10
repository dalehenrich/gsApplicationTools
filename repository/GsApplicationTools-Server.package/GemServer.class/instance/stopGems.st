service instance-control
stopGems
  self logControlEvent: 'Stop Gems: ' , self name.
  self ports do: [ :port | self executeStopGemCommand: port ]