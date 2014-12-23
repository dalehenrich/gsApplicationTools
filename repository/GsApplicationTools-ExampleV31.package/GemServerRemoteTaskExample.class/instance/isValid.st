testing
isValid
  ^ self shouldError
    ifTrue: [ self hasError and: [ self hasValue not ] ]
    ifFalse: [ self hasError not and: [ self hasValue ] ]