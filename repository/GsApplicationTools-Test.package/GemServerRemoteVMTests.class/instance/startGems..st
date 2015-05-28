private
startGems: gemServer
  self staticRemoteServer
    ifTrue: [ 
      System commitTransaction.
      self
        notify:
          'evaluate on server: abort; /home/gemserver/example --start=Test_Server' ]
    ifFalse: [ 
      gemServer startGems.
      self
        waitForGemServer: gemServer
        message: 'Gems did not start ' , self gemServerName ]