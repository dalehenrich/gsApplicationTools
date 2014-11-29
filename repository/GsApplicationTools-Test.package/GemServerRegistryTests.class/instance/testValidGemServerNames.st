tests
testValidGemServerNames
  #('m' '123' '_123_' '1_' '_')
    do: [ :gemName | MockGemServer register: gemName ]