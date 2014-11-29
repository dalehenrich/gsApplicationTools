service instance-private
recordGemPid: port
  "record gems pid in the pid file"

  | file pid pidFileName |
  pid := (System gemVersionReport at: 'processId') printString.
  pidFileName := self gemPidFileName: port.
  Transcript
    cr;
    show:
        'Record Gem pid: ' , pid printString , ' in: ' , pidFileName printString.
  (ServerFileDirectory on: self pidDirPath) assureExistence.
  file := GsFile openWriteOnServer: pidFileName.
  file nextPutAll: pid.
  file cr.
  file close