gsApplicationTools [![master branch:](https://travis-ci.org/GsDevKit/gsApplicationTools.png?branch=master)](https://travis-ci.org/GsDevKit/gsApplicationTools)
==================

[![Gitter](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/GsDevKit/gsApplicationTools?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

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
    load: #('default')
].
```

## Examples

- [REST example](https://github.com/GsDevKit/gsApplicationTools/blob/master/docs/rest.md#gemserver-support-for-zinc-rest)
