baseline
baseline: spec
  <baseline>
  spec
    for: #'common'
    do: [ 
      spec
        baseline: 'GLASS1'
          with: [ 
              spec
                loads: #('Base');
                repository: 'github://glassdb/glass:master/repository' ];
        yourself.
      spec
        package: 'GsApplication-Tools-Server';
        package: 'GsApplication-Tools-Tests'
          with: [ spec requires: #('GsApplication-Tools-Server') ];
        yourself.
      spec
        group: 'default' with: #('Core');
        group: 'Core' with: #('GsApplication-Tools-Server');
        group: 'Tests' with: #('GsApplication-Tools-Tests');
        group: 'CI' with: #('Tests');
        yourself ]