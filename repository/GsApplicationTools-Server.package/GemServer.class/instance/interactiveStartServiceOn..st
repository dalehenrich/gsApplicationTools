service instance-script
interactiveStartServiceOn: portOrResourceName
  "called from development environment ... service run in current vm."

  self
    interactiveStartServiceOn: portOrResourceName
    transactionMode: #'autoBegin'