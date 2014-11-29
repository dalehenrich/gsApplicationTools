service instance-control
stopGems
  self ports
    do: [ :port | 
      | pid |
      (GsFile openReadOnServer: (self gemPidFileName: port))
        ifNotNil: [ :file | 
          pid := file contentsOfEntireFile.
          file close.
          self performOnServer: 'kill ' , pid ] ]