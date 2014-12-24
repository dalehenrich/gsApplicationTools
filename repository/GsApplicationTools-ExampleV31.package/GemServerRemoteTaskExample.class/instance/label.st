accessing
label
  label ifNil: [ label := '(' , self asOop printString , ')' ].
  ^ label