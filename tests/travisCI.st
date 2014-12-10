"Load and run tests to be performed by TravisCI"
| gitPath fullSystemTest |
Transcript cr; show: 'travis---->travisCI.st'.
gitPath := (FileDirectory default directoryNamed: 'git_cache') fullName.

fullSystemTest := false.

Gofer new
  package: 'GsUpgrader-Core';
  url: 'http://ss3.gemtalksystems.com/ss/gsUpgrader';
  load.

fullSystemTest ifTrue: [ 
  (Smalltalk at: #GsUpgrader) upgradeGLASS1. "test against latest version of GLASS1 - clean tests"
] ifFalse: [
  (Smalltalk at: #GsUpgrader) upgradeGrease. "test against virgin version of GLASS"
].

GsDeployer deploy: [
  "Load GsApplicationTools... "
  Metacello new
    baseline: 'GsApplicationTools';
    repository: 'filetree://', gitPath, '/gsApplicationTools/repository';
    load: #('CI')
].

fullSystemTest ifTrue: [
  "Run all tests in image"
  TravisCISuiteHarness
    value: TestCase suite
    value: 'TravisCISuccess.txt'
    value: 'TravisCIFailure.txt'.
] ifFalse: [
  "Run the  GsApplicationTools tests"
  TravisCIHarness
    value: #( 'BaselineOfGsApplicationTools' )
    value: 'TravisCISuccess.txt' 
    value: 'TravisCIFailure.txt'.
].
