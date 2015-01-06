service instance-script
interactiveStartServiceOn: portOrNil
  "called from development environment ... service run in current vm."

  self interactiveStartServiceOn: portOrNil transactionMode: #'autoBegin'