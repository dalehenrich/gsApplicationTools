running
setUp
  | gemServer |
  super setUp.
  gemServer := GemServerRegistry gemServerNamed: self gemServerName.
  gemServer
    interactiveMode: true;
    gemServerExceptionSet:
        Error , gemServer class gemServerExceptionSet
            , gemServer class gemServerDebuggingExceptionSet.
  System commitTransaction