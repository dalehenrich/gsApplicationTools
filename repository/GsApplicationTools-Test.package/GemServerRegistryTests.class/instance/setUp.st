running
setUp
  super setUp.
  registry := GemServerRegistry singleton.
  GemServerRegistry _singleton: nil.
  GemServerRegistry
    addGemServerOfClass: GemServerMockServer
    withName: 'Mock Server'
    on: #(9001 9002 9003)
    using: MockGemServer.
  GemServerRegistry
    addGemServerOfClass: GemServerMockServer
    withName: 'Mock Server Default'
    using: MockGemServer