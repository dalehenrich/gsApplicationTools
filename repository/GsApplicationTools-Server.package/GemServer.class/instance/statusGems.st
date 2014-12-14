service instance-control
statusGems
  | pidList |
  pidList := ''.
  self logControlEvent: 'Status Gems: ' , self name.
  self ports
    do: [ :port | 
      | pidFilePath file |
      pidFilePath := self gemPidFileName: port.
      (GsFile openReadOnServer: pidFilePath)
        ifNotNil: [ :file | pidList := pidList , ' ' , file contents asNumber printString ] ].
  ^ self executeStatusGemCommand: pidList