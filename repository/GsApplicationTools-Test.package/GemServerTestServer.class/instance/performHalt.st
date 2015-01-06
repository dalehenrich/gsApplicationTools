actions
performHalt
  self halt.
  actionResult := #'halt'.
  self logAction: #'performHalt'