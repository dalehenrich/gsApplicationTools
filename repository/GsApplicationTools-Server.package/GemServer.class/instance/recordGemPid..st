service instance-private
recordGemPid: port
  "record gems pid in the pid file"

  | file pid pidFileName |
  pid := (System gemVersionReport at: 'processId') printString.
  pidFileName := self gemPidFileName: port.
  self
    scriptLogEvent: 'recordGemPid: ' , self name , ' on ' , port printString
    object:
      {pid.
      pidFileName}.
  (ServerFileDirectory on: self pidDirPath) assureExistence.
  file := GsFile openWriteOnServer: pidFileName.
  file nextPutAll: pid.
  file cr.
  file close