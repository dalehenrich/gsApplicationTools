service instance-private
gemPidFileName: port
  ^ self pidDirPath , '/' , self name , '_server-' , port asString , '.pid'