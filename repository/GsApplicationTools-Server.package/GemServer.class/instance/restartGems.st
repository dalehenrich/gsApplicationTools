service instance-control
restartGems
  self logControlEvent: 'Restart Gems: ' , self name.
  self stopGems.
  (Delay forSeconds: 3) wait.	"give gem a chance to close sockets"
  self startGems