service instance-private
gemPidFileName
  ^ self pidDir , '/' , self name , '_server-' , self portInstance asString
    , '.pid'