private
validateName: aString
  "<aString> will be used as part of a file name so disallow a name that cannot be used in a filename ... let's keep it simple"

  (self isValidName: aString)
    ifFalse: [ 
      self
        error:
          'GemServer name ' , aString printString
            , 'must consist of only alphanumeric or $_ characters.' ]