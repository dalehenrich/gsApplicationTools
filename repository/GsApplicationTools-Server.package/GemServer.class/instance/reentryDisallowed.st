private
reentryDisallowed
  ^ [ :methodName | self error: methodName , ' is not re-entrant' ]