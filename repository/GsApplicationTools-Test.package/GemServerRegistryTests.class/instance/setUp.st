running
setUp
  super setUp.
  registry := GemServerRegistry singleton.
  GemServerRegistry _singleton: nil.
  MockGemServer register: 'Mock_Server' on: #(9001 9002 9003).
  MockGemServer register: 'Mock_Server_Default'