running
setUp
  | gemServer |
  super setUp.
  gemServer := GemServer gemServerNamed: self gemServerName.
  gemServer
    interactiveMode: true;
    gemServerExceptionSet:
        Error , gemServer class gemServerExceptionSet
            , gemServer class gemServerDebuggingExceptionSet.
  System commitTransaction