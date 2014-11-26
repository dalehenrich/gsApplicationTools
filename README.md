gsApplicationTools [![master branch:](https://travis-ci.org/GsDevKit/gsApplicationTools.png?branch=master)](https://travis-ci.org/GsDevKit/gsApplicationTools)
==================

This repository includes scripts and code that allow a more convenient setup of a Gemstone server application 

## GemStone Installation

```Smalltalk
Gofer new
  package: 'GsUpgrader-Core';
  url: 'http://ss3.gemtalksystems.com/ss/gsUpgrader';
  load.
(Smalltalk at: #GsUpgrader) upgradeGrease.

GsDeployer deploy: [
  "Load GsApplicationTools packages"
  Metacello new
    baseline: 'GsApplicationTools';
    repository: 'github://GsDevKit/gsApplicationTools:master/repository';
    load: #('')
].
```
