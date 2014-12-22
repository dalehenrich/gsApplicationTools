accessing
forceInternalServerError
  forceInternalServerError ifNil: [ forceInternalServerError := false ].
  ^ forceInternalServerError