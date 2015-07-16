service instance-control
waitForStartGems: timeOutSeconds
  | pidList count |
  pidList := ''.
  count := 0.
  self logControlEvent: 'Wait for Gems: ' , self name.
  self portOrResourceNameList
    do: [ :portOrResourceName | 
      | pidFilePath file |
      pidFilePath := self gemPidFileName: portOrResourceName.
      [ GsFile existsOnServer: pidFilePath ]
        whileFalse: [ 
          (Delay forSeconds: 1) wait.
          count := count + 1.
          count > timeOutSeconds
            ifTrue: [ ^ false ] ] ].
  ^ true