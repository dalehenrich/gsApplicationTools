testing
isValid
  self response = self expectedResponse
    ifFalse: [ ^ false ].
  self status == self expectedStatus
    ifFalse: [ ^ false ].
  self expectedException
    ifNil: [ self exception ifNotNil: [ ^ false ] ]
    ifNotNil: [ :expected | 
      (self exception isKindOf: expected)
        ifFalse: [ ^ false ] ].
  ^ true