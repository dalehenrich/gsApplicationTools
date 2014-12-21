transactions
doSimpleTransaction: aBlock
  "I do an unconditional commit. Caller is responsible for restoring proper commit state"

  ^ self class doSimpleTransaction: aBlock