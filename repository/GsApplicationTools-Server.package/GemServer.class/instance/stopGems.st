service instance-control
stopGems
  self ports
    do: [ :port | 
      | pid pidFilePath |
      pidFilePath := self gemPidFileName: port.
      (GsFile openReadOnServer: pidFilePath)
        ifNotNil: [ :file | 
          pid := file contentsOfEntireFile.
          file close.
          GsFile removeServerFile: pidFilePath.
          [ self performOnServer: 'kill ' , pid ]
            on: Error
            do: [ :ignore |  ] ] ]