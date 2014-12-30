operations
outOfMemoryPersistentMethod
  | res |
  res := super outOfMemoryPersistentMethod.
  self doBeginTransaction.
  ^ res