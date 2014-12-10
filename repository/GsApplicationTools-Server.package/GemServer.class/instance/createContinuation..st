private
createContinuation: label
  GRPlatform current
    doTransaction: [ DebuggerLogEntry createContinuationLabeled: label ]