actions
performError
  self foo.
  actionResult := #'RESUMED????'.
  self logAction: #'performError'