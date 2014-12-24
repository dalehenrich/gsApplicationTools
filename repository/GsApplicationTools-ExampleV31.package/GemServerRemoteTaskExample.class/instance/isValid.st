testing
isValid
  ^ self expectedException notNil
    ifTrue: [ 
      self hasError
        and: [ self hasValue not and: [ self exception isKindOf: self expectedException ] ] ]
    ifFalse: [ self hasError not and: [ self hasValue ] ]