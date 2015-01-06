accessing
queueCounterIncrement
  "independent of transactions"

  ^ System persistentCounterAt: self queueCounterIndex incrementBy: 1