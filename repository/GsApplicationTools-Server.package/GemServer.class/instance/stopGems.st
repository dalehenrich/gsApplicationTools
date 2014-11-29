service instance-control
stopGems
  self ports do: [ :port | self executeStopGemCommand: port ]