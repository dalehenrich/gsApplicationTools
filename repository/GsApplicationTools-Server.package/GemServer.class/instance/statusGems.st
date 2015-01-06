service instance-control
statusGems
  | pidList |
  pidList := ''.
  self logControlEvent: 'Status Gems: ' , self name.
  self portOrResourceNameList
    do: [ :portOrResourceName | 
      | pidFilePath file |
      pidFilePath := self gemPidFileName: portOrResourceName.
      (GsFile openReadOnServer: pidFilePath)
        ifNotNil: [ :file | pidList := pidList , ' ' , file contents asNumber printString ] ].
  ^ self executeStatusGemCommand: pidList