GemServer support of Zinc REST
-----------------

The REST examples in this document are base on using the **ZnExampleStorageRestServerDelegate**.
From the class comment:

> I offer a REST interface on /storage with CRUD operations on JSON maps. 
> I automatically use the call hierarchy below ZnExampleStorageRestCall.

**Note: All of the code snippets in this section should be evaluated in a tODE shell window.**

#### Installation
Install Zinc REST support ([**smalltalk code**](#zinc-rest-installation)):

```Shell
project load --loads=REST --baseline \
        --repository=github://GsDevKit/zinc:issue_58/repository ZincHTTPComponents  
```

Browse the classes used in this example:

```Shell
browse class --exact --hier ZnExampleStorageRestCall ZnExampleStorageRestServerDelegate \
       ZnAbstractExampleStorageRestServerDelegateTest ZnGemServer
```

#### tODE `rest` script
Mount the example script directory in your `/home` directory:  

```Shell
mount /sys/stone/repos/gsApplicationTools/tode/ /home gemServerExample
cd /home/gemServerExample
```

Script synopsis:

```
./rest [-h|--help]
     --register=<gemServer-name> [--port=<server-port>] [--logTo=transcript|objectLog] \
                                 [--log=all|debug|error|info]
     --unregister=<gemServer-name>
     --client=<gemServer-name> [--path=<path>] [--post=`expression`]
     --client=<gemServer-name> [--get=<path>]
```

#### `rest` GemServer control commands

Register the REST example GemServer ([**smalltalk code**](#register-rest-gemserver)):

```Shell
./rest --register=rest --port=1720 --log=all --logTo=objectLog
```

Start/stop/restart GemServer ([**smalltalk code**](#startstoprestart-gemserver)):

```Shell
./rest --start=rest
./rest --stop=rest
./rest --restart=rest
```

Unregister the GemServer ([**smalltalk code**](#unregister-gemserver]): 

```Shell
./rest --unregister=rest
```

#### `rest` Client commands

```Shell
./rest
```

##Smalltalk Appendix

The following Smalltalk snippets are representative of the code that is executed by the tODE commands.

####Zinc REST Installation

The **tODE** command:

```Shell
project load --loads=REST --baseline \
        --repository=github://GsDevKit/zinc:issue_58/repository ZincHTTPComponents  
```

executes the following **Smalltalk**:

```Smalltalk
GsDeployer bulkMigrate: [
  Metacello new
    baseline: 'ZincHTTPComponents';
    repository: 'github://GsDevKit/zinc:issue_58/repository';
    load: 'REST' ].
```

####Register REST GemServer

The **tODE** command:

```Shell
./rest --register=rest --port=1720 --log=all --logTo=objectLog
```

executes the following **Smalltalk**:

 
```Smalltalk
(ZnGemServer register: 'rest')
    ports: #(1720);
    logFilter: nil;
    logToObjectLog;
    delegate: ZnExampleStorageRestServerDelegate new;
    register.
```

####Start/Stop/Restart GemServer

The **tODE** commands:

```Shell
./rest --start=rest
./rest --stop=rest
./rest --restart=rest
```

executes the following **Smalltalk**:

```Smalltalk
(GemServerRegistry gemServerNamed: 'rest') startGems.
(GemServerRegistry gemServerNamed: 'rest') stopGems.
(GemServerRegistry gemServerNamed: 'rest') restartGems.
```

####Unregister GemServer

The **tODE** command:

```Shell
./rest --unregister=rest
```

executes the following **Smalltalk**:

```Smalltalk
(GemServerRegistry gemServerNamed: 'rest') unregister.
```

