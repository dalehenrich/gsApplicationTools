service instance-private
recordGemPid
  "record gems pid in the pid file"

  | file |
  (GsFile isServerDirectory: self pidDir)
    ifFalse: [ ^ nil ].
  file := GsFile openWriteOnServer: self gemPidFileName.
  file nextPutAll: (System gemVersionReport at: 'processId') printString.
  file cr.
  file close