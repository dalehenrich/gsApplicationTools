running
setUp
  | gemServer |
  super setUp.
  gemServer := GemServerTestServer register: self gemServerName.
  gemServer
    gemServerExceptionSet:
      Error , gemServer class gemServerExceptionSet
        , gemServer class gemServerDebuggingExceptionSet.
  System commitTransaction