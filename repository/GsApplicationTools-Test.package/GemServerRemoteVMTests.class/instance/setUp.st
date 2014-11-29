running
setUp
  super setUp.
  (MockGemServer register: 'Mock_Server') useEventLog: false.
  GemServerMockServer reset