accessing
eventLog
  EvenLog ifNil: [ EvenLog := OrderedCollection new ].
  ^ EvenLog