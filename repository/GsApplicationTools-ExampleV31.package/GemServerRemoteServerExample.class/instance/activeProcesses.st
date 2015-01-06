accessing
activeProcesses
  activeProcesses value ifNil: [ activeProcesses value: IdentitySet new ].
  ^ activeProcesses value