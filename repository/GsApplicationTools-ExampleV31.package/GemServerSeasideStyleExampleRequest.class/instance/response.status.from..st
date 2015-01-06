actions
response: aResponse status: aSymbol from: aGemServer
  "I don't want this transaction to be part of the server logic, because techically writing a 
   response does not need a transaction as we should be putting bits on the wire ... but this 
   implementation needs a commit to store the response with the request"

  aGemServer
    doTransaction: [ 
      response := aResponse.
      status := aSymbol ]