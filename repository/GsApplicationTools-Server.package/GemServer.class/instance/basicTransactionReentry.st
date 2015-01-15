accessing
basicTransactionReentry
  basicTransactionReentry value
    ifNil: [ basicTransactionReentry value: self reentryAllowed ].
  ^ basicTransactionReentry value