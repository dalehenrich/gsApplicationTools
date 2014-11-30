service instance-control
restartGems
  self logControlEvent: 'Restart Gems: ' , self name.
  self
    stopGems;
    startGems