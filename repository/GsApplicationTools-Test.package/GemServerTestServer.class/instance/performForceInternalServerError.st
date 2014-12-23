actions
performForceInternalServerError
  actionResult := #'forceInternalServerError'.
  forceInternalServerError := true.
  self logAction: #'performForceInternalServerError'