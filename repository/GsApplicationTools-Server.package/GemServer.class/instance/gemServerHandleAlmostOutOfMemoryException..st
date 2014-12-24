exception dispatching
gemServerHandleAlmostOutOfMemoryException: exception
  "treat like an error and unwind stack and re-enable handling with expectation that temp objects 
   are on the stack"

  AlmostOutOfMemory enable.
  self gemServerHandleErrorException: exception