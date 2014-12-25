service instance-control
startGems
  self initCrashLog.
  System commitTransaction
    ifFalse: [ self error: 'Commit transaction failed before startGems' ].
  self logControlEvent: 'Start Gems: ' , self name.
  self ports
    do: [ :port | 
      | pidFilePath |
      pidFilePath := self gemPidFileName: port.
      (GsFile existsOnServer: pidFilePath)
        ifTrue: [ 
          self
            error:
              'Pid file exists for port: ' , port printString , '. Try restart command.' ].
      self executeStartGemCommand: port ]