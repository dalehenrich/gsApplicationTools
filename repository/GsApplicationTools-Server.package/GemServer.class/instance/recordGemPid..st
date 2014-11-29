service instance-private
recordGemPid: port
  "record gems pid in the pid file"

  | file |
  (GsFile isServerDirectory: self pidDirPath)
    ifFalse: [ ^ nil ].
  file := GsFile openWriteOnServer: (self gemPidFileName: port).
  file nextPutAll: (System gemVersionReport at: 'processId') printString.
  file cr.
  file close