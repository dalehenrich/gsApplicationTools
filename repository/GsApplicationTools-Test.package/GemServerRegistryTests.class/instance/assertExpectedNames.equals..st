private
assertExpectedNames: expected equals: actual
  self assert: expected size = actual size.
  expected do: [ :name | self assert: (actual includes: name) ]