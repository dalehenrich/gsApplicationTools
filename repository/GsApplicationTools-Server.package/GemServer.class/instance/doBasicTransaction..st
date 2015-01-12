transactions-support
doBasicTransaction: aBlock
  "I do an unconditional commit and I am not reentrant
   If running in manual transaction mode, the system will be outside of transaction upon 
    returning.
   Return true, if the transaction completed without conflicts.
   If the transaction fails, return false and the caller is responsible for post commit failure
   processing."

  self transactionMutex
    critical: [ 
      | commitResult oldValue |
      self basicTransactionReentry value: 'doBasicTransaction:'.	"throw error upon reentry"
      oldValue := self basicTransactionReentry.
      [ 
      self basicTransactionReentry: self reentryDisallowed.
      self doBeginTransaction.
      aBlock value ]
        ensure: [ 
          "workaround for Bug 42963: ensure: block executed twice (don't return from ensure: block)"
          commitResult := self doCommitTransaction.
          self basicTransactionReentry: oldValue ].
      ^ commitResult ]