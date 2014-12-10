accessing
eventLog
  eventLog ifNil: [ eventLog := OrderedCollection new ].
  ^ eventLog