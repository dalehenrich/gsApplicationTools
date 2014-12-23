actions
addToQueue: gemServer
  gemServer doSimpleTransaction: [ self class queue add: self ].
  self class queueCounterIncrement	"independent of transactions"