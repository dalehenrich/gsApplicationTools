error handling
internalServerError: exception titled: title
  "If I am not in transaction, then it is safe to commit the continuation.
   If I am in transaction a commit is not safe (by default) because we want to avoid committing any partial 
     persistent state."

  self
    internalServerError: exception
    titled: title
    shouldCommit: System inTransaction not