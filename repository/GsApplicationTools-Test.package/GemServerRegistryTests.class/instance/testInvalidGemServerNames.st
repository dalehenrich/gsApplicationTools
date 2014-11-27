tests
testInvalidGemServerNames
  #(' ' '.' '/' '?')
    do: [ :gemName | 
      self
        should: [ GemServerRegistry addGemServerOfClass: GemServerMockServer withName: gemName ]
        raise: Error ]