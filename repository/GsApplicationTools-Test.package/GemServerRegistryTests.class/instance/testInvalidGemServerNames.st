tests
testInvalidGemServerNames
  #(' ' '.' '/' '?')
    do: [ :gemName | self should: [ MockGemServer register: gemName ] raise: Error ]