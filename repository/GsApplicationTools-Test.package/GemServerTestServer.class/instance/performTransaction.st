actions
performTransaction
  actionResult := messageObject + 1.
  self class persistentRoot at: #'performTransaction' put: actionResult.
  self logAction: #'performTransaction'