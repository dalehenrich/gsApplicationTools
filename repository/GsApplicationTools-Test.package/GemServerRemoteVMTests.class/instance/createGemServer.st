private
createGemServer
  | gemServer |
  gemServer := super createGemServer.
  self interactiveRemoteServer
    ifTrue: [ gemServer interactiveMode: true ].
  ^ gemServer