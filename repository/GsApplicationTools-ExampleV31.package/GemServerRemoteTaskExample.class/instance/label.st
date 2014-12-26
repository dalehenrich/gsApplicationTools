accessing
label
  label ifNil: [ ^ '(' , self asOop printString , ')' ].
  ^ label