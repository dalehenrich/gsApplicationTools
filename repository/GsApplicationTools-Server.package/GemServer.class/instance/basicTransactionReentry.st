accessing
basicTransactionReentry
  basicTransactionReentry value
    ifNil: [ 
      self _setNoStubbing.	"as long as I am in memory prevent stubbing of my instance variables ... I will stay in memory as long as I am referenced from stack.."
      basicTransactionReentry value: self reentryAllowed ].
  ^ basicTransactionReentry value