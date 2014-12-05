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

Script man page:

```Shell
./rest --help
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

##### Post
Register a dictionary with the REST server using the `post` command ([**smalltalk code**](#client-post-command)):

```Shell
./rest --client=rest --uri=objects --post=`Dictionary with: #x -> 1 with: #y -> 1`; edit
```

The command returns the URI of the object for example: `/storage/objects/1001`.

##### Get
The `get` command returns an object ([**smalltalk code**](#client-get-command)): 

```Shell
./rest --client=rest --uri=/objects/1001 --get; edit
```

Here's the contents of tODE inspector:

```
.        -> aDictionary( 'x'->1, 'y'->1, 'object-uri'->'/storage/objects/1001')
(class)@ -> Dictionary
(oop)@   -> 217431809
1@       -> 'object-uri'->'/storage/objects/1001'
2@       -> 'x'->1
3@       -> 'y'->1
```

```Shell
./rest
```

---

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

####Client `post` command

The **tODE** command:

```Shell
./rest --client=rest --uri=objects --post=`Dictionary with: #x -> 1 with: #y -> 1`
```

executes the following **Smalltalk**:

```Smalltalk
  ZnClient new
    url: 'http://localHost:1720';
    addPathSegment: #'storage';
    accept: ZnMimeType applicationJson;
    contentReader: [ :entity | 
        entity ifNotNil: [ NeoJSONReader fromString: entity contents ] ];
    contentWriter: [ :object | 
        ZnEntity 
            with: (NeoJSONWriter toString: object) 
            type: ZnMimeType applicationJson ];
    addPathSegment: 'objects';
    contents: (Dictionary with: #'x' -> 1 with: #'y' -> 1);
    post
```

####Client `get` command

The **tODE** command:

```Shell
./rest --client=rest --uri=/objects/1001 --get
```

executes the following **Smalltalk**:

```Smalltalk
  ZnClient new
    url: 'http://localHost:1720';
    addPathSegment: #'storage';
    accept: ZnMimeType applicationJson;
    contentReader: [ :entity | entity ifNotNil: [ NeoJSONReader fromString: entity contents ] ];
    contentWriter: [ :object | ZnEntity with: (NeoJSONWriter toString: object) type: ZnMimeType applicationJson ];
    addPath: 'objects/1001';
    get;
    contents
```

