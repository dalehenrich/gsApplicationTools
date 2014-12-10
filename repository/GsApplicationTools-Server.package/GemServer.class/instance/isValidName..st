private
isValidName: aString
  "<aString> will be used as part of a file name so disallow a name that cannot be used in a filename ... let's keep it simple"

  aString size == 0
    ifTrue: [ ^ false ].
  aString
    do: [ :c | 
      (c == $_ or: [ c isAlphaNumeric ])
        ifFalse: [ ^ false ] ].
  ^ true