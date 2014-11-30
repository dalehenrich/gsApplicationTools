accessing
eventLog
  EventLog ifNil: [ EventLog := OrderedCollection new ].
  ^ EventLog