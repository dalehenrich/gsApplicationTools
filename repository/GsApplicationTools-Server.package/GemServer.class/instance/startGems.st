service instance-control
startGems
  self initCrashLog.
  System commitTransaction
    ifFalse: [ self error: 'Commit transaction failed before startGems' ].
  self logControlEvent: 'Start Gems: ' , self name.
  self portOrResourceNameList
    do: [ :portOrResourceName | 
      | pidFilePath |
      pidFilePath := self gemPidFileName: portOrResourceName.
      (GsFile existsOnServer: pidFilePath)
        ifTrue: [ 
          self
            error:
              'Pid file exists for port or resource: ' , portOrResourceName printString
                , '. Try restart command.' ].
      self executeStartGemCommand: portOrResourceName ]