service instance-private
gemPidFileName: port
  ^ self pidDir , '/' , self name , '_server-' , port asString , '.pid'