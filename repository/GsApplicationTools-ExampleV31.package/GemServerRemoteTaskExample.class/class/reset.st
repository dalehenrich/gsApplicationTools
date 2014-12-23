instance creation
reset
  InProcess := Queue := nil.
  System persistentCounterAt: self queueCounterIndex put: 0