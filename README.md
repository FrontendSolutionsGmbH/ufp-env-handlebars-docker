# ufp-env-handlebars-docker
UFP Docker image that uses handlebar template folder and environment variables as input for handlebars rendering and hosting the parsed templates under localhost:3000


# Prerequisites

this is a dockerizd multi stage build, so the only installation that is required is

 - [Docker](https://www.docker.com/)
 
 ## Node
 
 since it is a node application, when developing, or when you want to improve the build process
 you have to install 
 
 
 - [Node](https://www.nodejs.org/)
 
 and can execute `yarn install` in the './js/' folder
 
 

# Quickstart

# Install node dependencies 

for now you have to install the node modules manually, this will be replaced with a webpack/rollup bundler to
get rid of huge node modules folder

# Build docker

build the docker file using the 

	./test.sh 
	
script, it performs the build as well, trigger successive builds using

	./test.sh -c
	
or when you want to inspect the infrastructure keep it alive using

	./test.sh -t
	

# Tryout/Test

after the successful build you can execute

	docker run  -p 3000:3000 ufp/env-handlebars 

or use the configured docker-compose in the ./ct/ folder

	cd ct
	docker-compose up
	

# Development

# Executing node app

as of now, you have to trigger ./js/build.sh for creating the dist folder, a watch for automatically executing the
dist refresh ist not yet build in

after the build execute the functionality (pars env and parse handlebar folders to public) in the ./js/dist folder

keep in mind that you have to provide the environment variable config manually in this case using normal `export VAR=value`
shell functionality

	WARNING:
	
	this particular repository onlu uses the service and test stacks due to the nature of this repo

# Acknowledgement 

this repository uses a generalization approach for the microservice development, the stack.sh script is used to control
the 4 branches of possible stacks which are:
- Infrastructure - the stack used for everything that is not the service but the service depends on
- Debug - Any debug tools ( like this repository ) that may help yourself keeps track of what is going on
- Service - the service itself, this stack should contain only the service under development
- Test - we use robot framework for testing, nevertheless, the test stack executes against a running infra and service stack

important options are 
- -c which forces a recreation of the stack, so, for re-running e.g. the test suite you dont need to rebuild, only if you work on the particular stack you should use -c 

 
and 

- -b this param is background running of the stack, so when working one can easily start/stop the particular services running in backgrojund


	$ ./stack.sh --help 
     Starts/Stops the local stack and their debug-tools.
     Options:
       -h          Show this help
       -p          Pulls the latest docker images
       -b          starts stack in background with -d
       -c          recreate container stacks
       -l          Show the logs
       -u <stack>  Starts the given stack. Possible stacks see below!
       -d <stack>  Stops the given stack. Possible stacks see below!
    
       Possible Stacks:
         infra     The infrastructure needed by the services
         service   The order-process involved services
         debug     The debug tools
         test     The Robotframework test run
         all       All these stacks
    
     Default behavior: Starts the service only
    
     (continued) author: ck@froso.de
     (initial) author: s.schumann@tarent.de

## Quickstart log

	./test.sh
	./test.sh 
    ------------------------------------------------------------------------------
    Bringing up Infrastructure 
    ------------------------------------------------------------------------------
    Stack.sh called
    SCRIPT_PATH=/Projects/FROSO/ufp-env-handlebars-docker/stack.sh
    SCRIPT_NAME=stack.sh
    SCRIPT_HOME=/Projects/FROSO/ufp-env-handlebars-docker/
    START=0
    STOP=1
    STACK_INFRA=0
    STACK_DEBUG=0
    STACK_SERVICE=1
    STACK_TEST=0
    CREATE=1
    Stopping Service Stack
    ------------------------------------------------------------------------------
    Building ufp-env-handlebars 
    ------------------------------------------------------------------------------
    ------------------------------------------------------------------------------
    Building ufp-env-handlebars docker file 
    ------------------------------------------------------------------------------
    WARNING: Error loading config file: /home/ckleinhuis/.docker/config.json: Invalid auth configuration file
    Sending build context to Docker daemon  6.901MB
    Step 1/15 : FROM node:8-slim as builder
    8-slim: Pulling from library/node
    57936531d1ee: Pull complete 
    b186cf19f9ed: Pull complete 
    eadbf8312262: Pull complete 
    cf528b18b6ce: Pull complete 
    075c4f074e90: Pull complete 
    Digest: sha256:94512a7aa8e6cb1c9fa72b4e05902e7ced1a4312c3597718e5db67025136ff2e
    Status: Downloaded newer image for node:8-slim
     ---> 5c11cd94edcb
    Step 2/15 : ENV PATH ${PATH}:/ufp-env-handlebars-build/node_modules/.bin
     ---> Running in 47a9a070e05c
    Removing intermediate container 47a9a070e05c
     ---> 0aa73bd972d0
    Step 3/15 : COPY js/src /ufp-env-handlebars-build/src
     ---> 3c49282bc70f
    Step 4/15 : COPY js/static /ufp-env-handlebars-build/static
     ---> e5b59003dca4
    Step 5/15 : COPY js/build.sh /ufp-env-handlebars-build/build.sh
     ---> 1220ee140d60
    Step 6/15 : COPY js/package.json /ufp-env-handlebars-build/package.json
     ---> 9344e74ea6a1
    Step 7/15 : COPY js/yarn.lock /ufp-env-handlebars-build/yarn.lock
     ---> 632bee3e4b74
    Step 8/15 : WORKDIR /ufp-env-handlebars-build
     ---> Running in 78147be7e19a
    Removing intermediate container 78147be7e19a
     ---> a7d5e6c0f5a7
    Step 9/15 : RUN yarn install
     ---> Running in 85ae3d7930a2
    yarn install v1.9.4
    [1/4] Resolving packages...
    [2/4] Fetching packages...
    info fsevents@1.2.4: The platform "linux" is incompatible with this module.
    info "fsevents@1.2.4" is an optional dependency and failed compatibility check. Excluding it from installation.
    [3/4] Linking dependencies...
    [4/4] Building fresh packages...
    success Saved lockfile.
    Done in 10.30s.
    Removing intermediate container 85ae3d7930a2
     ---> 3c54d722e37f
    Step 10/15 : RUN ./build.sh
     ---> Running in cf18dca3bd91
    ------------------------------------------------------------------------------
    Building ufp-env-handlebars js executables
    ------------------------------------------------------------------------------
    ------------------------------------------------------------------------------
    Cleaning ./dist folder
    ------------------------------------------------------------------------------
    ------------------------------------------------------------------------------
    Executing Webpack for server/index.js
    ------------------------------------------------------------------------------
    Hash: bdbe0ffa1f931e17b05e
    Version: webpack 4.20.2
    Time: 3430ms
    Built at: 2018-10-13 16:45:12
       Asset     Size  Chunks             Chunk Names
    index.js  414 KiB       0  [emitted]  null
    Entrypoint null = index.js
      [2] external "path" 42 bytes {0} [built]
      [4] external "fs" 42 bytes {0} [built]
      [6] external "buffer" 42 bytes {0} [built]
      [9] external "stream" 42 bytes {0} [built]
     [19] external "http" 42 bytes {0} [built]
     [21] external "util" 42 bytes {0} [built]
     [29] external "events" 42 bytes {0} [built]
     [32] external "net" 42 bytes {0} [built]
     [40] external "querystring" 42 bytes {0} [built]
     [41] external "url" 42 bytes {0} [built]
     [48] external "crypto" 42 bytes {0} [built]
     [52] ./src/server/server.js 598 bytes {0} [built]
     [65] external "tty" 42 bytes {0} [built]
    [102] ./node_modules/express/lib sync 160 bytes {0} [built]
    [108] (webpack)/buildin/module.js 519 bytes {0} [built]
        + 109 hidden modules
    
    WARNING in ./node_modules/express/lib/view.js 81:13-25
    Critical dependency: the request of a dependency is an expression
     @ ./node_modules/express/lib/application.js
     @ ./node_modules/express/lib/express.js
     @ ./node_modules/express/index.js
     @ ./src/server/server.js
    ------------------------------------------------------------------------------
    Executing Webpack for handlebars/index.js
    ------------------------------------------------------------------------------
    Hash: 46fcf3b25e748d8829eb
    Version: webpack 4.20.2
    Time: 2020ms
    Built at: 2018-10-13 16:45:14
       Asset     Size  Chunks             Chunk Names
    index.js  107 KiB       0  [emitted]  null
    Entrypoint null = index.js
     [0] external "path" 42 bytes {0} [built]
     [1] external "fs" 42 bytes {0} [built]
     [3] external "util" 42 bytes {0} [built]
     [7] external "assert" 42 bytes {0} [built]
    [11] ./src/handlebars/handlebars.js 2.5 KiB {0} [built]
    [20] external "events" 42 bytes {0} [built]
        + 18 hidden modules
    ------------------------------------------------------------------------------
    Manually copying static assets
    ------------------------------------------------------------------------------
    Removing intermediate container cf18dca3bd91
     ---> 5ef98e2ba0ab
    Step 11/15 : FROM node:8-slim
     ---> 5c11cd94edcb
    Step 12/15 : COPY --from=builder /ufp-env-handlebars-build/dist /ufp-env-handlebars
     ---> 3929813f04b1
    Step 13/15 : WORKDIR /ufp-env-handlebars
     ---> Running in a06d0d73a2bb
    Removing intermediate container a06d0d73a2bb
     ---> 27a16151f1aa
    Step 14/15 : EXPOSE 3000:3000
     ---> Running in 900c83f18722
    Removing intermediate container 900c83f18722
     ---> b808609ea7c6
    Step 15/15 : CMD ./execute.sh
     ---> Running in 4ae22369dce8
    Removing intermediate container 4ae22369dce8
     ---> 2529a1b4a34e
    Successfully built 2529a1b4a34e
    Successfully tagged ufp/env-handlebars:latest
    ------------------------------------------------------------------------------
    Building finished 
    ------------------------------------------------------------------------------
    ------------------------------------------------------------------------------
    docker run  -p 3000:3000 ufp/env-handlebars 
    ------------------------------------------------------------------------------
    Removing network ct_default
    /Projects/FROSO/ufp-env-handlebars-docker
    Stopping Service Stack End
    Stack.sh called
    SCRIPT_PATH=/Projects/FROSO/ufp-env-handlebars-docker/stack.sh
    SCRIPT_NAME=stack.sh
    SCRIPT_HOME=/Projects/FROSO/ufp-env-handlebars-docker/
    START=1
    STOP=0
    STACK_INFRA=0
    STACK_DEBUG=0
    STACK_SERVICE=1
    STACK_TEST=0
    CREATE=1
    Starting Service Stack
    ./stack.sh: line 125: ./build.sh: No such file or directory
    ufp-env-handlebars uses an image, skipping
    ufp-env-handlebars2 uses an image, skipping
    Creating network "ct_default" with the default driver
    Creating ct_ufp-env-handlebars_1  ... done
    Creating ct_ufp-env-handlebars2_1 ... done
    /Projects/FROSO/ufp-env-handlebars-docker
    Returning Service Stack
    ------------------------------------------------------------------------------
    Executing component test 
    ------------------------------------------------------------------------------
    Stack.sh called
    SCRIPT_PATH=/Projects/FROSO/ufp-env-handlebars-docker/stack.sh
    SCRIPT_NAME=stack.sh
    SCRIPT_HOME=/Projects/FROSO/ufp-env-handlebars-docker/
    START=0
    STOP=1
    STACK_INFRA=0
    STACK_DEBUG=0
    STACK_SERVICE=0
    STACK_TEST=1
    CREATE=1
    WARNING: Found orphan containers (ct_ufp-env-handlebars_1, ct_ufp-env-handlebars2_1) for this project. If you removed or renamed this service in your compose file, you can run this command with the --remove-orphans flag to clean it up.
    Removing network ct_default
    ERROR: network ct_default id c9696a5087dfced953b22a737a60fcc5eb9bdfb27465c09f709e52038b46346a has active endpoints
    /Projects/FROSO/ufp-env-handlebars-docker
    Stack.sh called
    SCRIPT_PATH=/Projects/FROSO/ufp-env-handlebars-docker/stack.sh
    SCRIPT_NAME=stack.sh
    SCRIPT_HOME=/Projects/FROSO/ufp-env-handlebars-docker/
    START=1
    STOP=0
    STACK_INFRA=0
    STACK_DEBUG=0
    STACK_SERVICE=0
    STACK_TEST=1
    CREATE=1
    Building robot-test
    Step 1/5 : FROM manycoding/robotframework:alpine
    alpine: Pulling from manycoding/robotframework
    81033e7c1d6a: Pull complete
    9b61101706a6: Pull complete
    32753c857922: Pull complete
    cf650ef98e41: Pull complete
    14b06c8013e3: Pull complete
    Digest: sha256:6e3d46aa49750418776700f5b530c420e7d9beb8c2687c1f4f38f731c7a91dd1
    Status: Downloaded newer image for manycoding/robotframework:alpine
     ---> ca17b330fe33
    Step 2/5 : RUN pip install robotframework-requests==0.4.7
     ---> Running in 2d03df45e379
    Collecting robotframework-requests==0.4.7
      Downloading https://files.pythonhosted.org/packages/6c/29/42b7f193595e71e4558da5611ebd860d2cfbf3accebf9c3650e62829baee/robotframework-requests-0.4.7.tar.gz
    Requirement already satisfied: robotframework in /usr/local/lib/python2.7/site-packages (from robotframework-requests==0.4.7) (3.0.4)
    Collecting requests (from robotframework-requests==0.4.7)
      Downloading https://files.pythonhosted.org/packages/65/47/7e02164a2a3db50ed6d8a6ab1d6d60b69c4c3fdf57a284257925dfc12bda/requests-2.19.1-py2.py3-none-any.whl (91kB)
    Collecting idna<2.8,>=2.5 (from requests->robotframework-requests==0.4.7)
      Downloading https://files.pythonhosted.org/packages/4b/2a/0276479a4b3caeb8a8c1af2f8e4355746a97fab05a372e4a2c6a6b876165/idna-2.7-py2.py3-none-any.whl (58kB)
    Collecting chardet<3.1.0,>=3.0.2 (from requests->robotframework-requests==0.4.7)
      Downloading https://files.pythonhosted.org/packages/bc/a9/01ffebfb562e4274b6487b4bb1ddec7ca55ec7510b22e4c51f14098443b8/chardet-3.0.4-py2.py3-none-any.whl (133kB)
    Collecting urllib3<1.24,>=1.21.1 (from requests->robotframework-requests==0.4.7)
      Downloading https://files.pythonhosted.org/packages/bd/c9/6fdd990019071a4a32a5e7cb78a1d92c53851ef4f56f62a3486e6a7d8ffb/urllib3-1.23-py2.py3-none-any.whl (133kB)
    Collecting certifi>=2017.4.17 (from requests->robotframework-requests==0.4.7)
      Downloading https://files.pythonhosted.org/packages/df/f7/04fee6ac349e915b82171f8e23cee63644d83663b34c539f7a09aed18f9e/certifi-2018.8.24-py2.py3-none-any.whl (147kB)
    Building wheels for collected packages: robotframework-requests
      Running setup.py bdist_wheel for robotframework-requests: started
      Running setup.py bdist_wheel for robotframework-requests: finished with status 'done'
      Stored in directory: /root/.cache/pip/wheels/ca/9d/f3/2e457eb9e49f328c2e9f1bfaa467df9bf54b42524c92d21af6
    Successfully built robotframework-requests
    Installing collected packages: idna, chardet, urllib3, certifi, requests, robotframework-requests
    Successfully installed certifi-2018.8.24 chardet-3.0.4 idna-2.7 requests-2.19.1 robotframework-requests-0.4.7 urllib3-1.23
    You are using pip version 10.0.1, however version 18.1 is available.
    You should consider upgrading via the 'pip install --upgrade pip' command.
    Removing intermediate container 2d03df45e379
     ---> 2cc8c6cffea3
    Step 3/5 : VOLUME /robot/tests
     ---> Running in 1cba8f21bbef
    Removing intermediate container 1cba8f21bbef
     ---> d2a67a9da3c9
    Step 4/5 : VOLUME /robot/report
     ---> Running in dc1fd1969939
    Removing intermediate container dc1fd1969939
     ---> 40108a5449fa
    Step 5/5 : ENTRYPOINT [ "robot", "-d", "/robot/report", "/robot/tests"]
     ---> Running in 89ae9358de61
    Removing intermediate container 89ae9358de61
     ---> 2fd0bb7ecbe6
    Successfully built 2fd0bb7ecbe6
    Successfully tagged ct_robot-test:latest
    WARNING: Found orphan containers (ct_ufp-env-handlebars_1, ct_ufp-env-handlebars2_1) for this project. If you removed or renamed this service in your compose file, you can run this command with the --remove-orphans flag to clean it up.
    Creating ct_robot-test_1 ... done
    Attaching to ct_robot-test_1
    robot-test_1  | ==============================================================================
    robot-test_1  | Tests                                                                         
    robot-test_1  | ==============================================================================
    robot-test_1  | Tests.Test                                                                    
    robot-test_1  | ==============================================================================
    robot-test_1  | Tests.Test.ComponentTest :: This test assumes that the docker-compose-servi...
    robot-test_1  | ==============================================================================
    robot-test_1  | Check Service 1 With Current ENV Config in Docker-Compose.yml :: T... | PASS |
    robot-test_1  | ------------------------------------------------------------------------------
    robot-test_1  | Check Service 1 Path 2 With Current ENV Config in Docker-Compose.y... | PASS |
    robot-test_1  | ------------------------------------------------------------------------------
    robot-test_1  | Check Service 2 With Current ENV Config in Docker-Compose.yml :: T... | PASS |
    robot-test_1  | ------------------------------------------------------------------------------
    robot-test_1  | Tests.Test.ComponentTest :: This test assumes that the docker-comp... | PASS |
    robot-test_1  | 3 critical tests, 3 passed, 0 failed
    robot-test_1  | 3 tests total, 3 passed, 0 failed
    robot-test_1  | ==============================================================================
    robot-test_1  | Tests.Test.HelloWorld                                                         
    robot-test_1  | ==============================================================================
    robot-test_1  | HelloWorld                                                            Hello World
    robot-test_1  | | PASS |
    robot-test_1  | ------------------------------------------------------------------------------
    robot-test_1  | Tests.Test.HelloWorld                                                 | PASS |
    robot-test_1  | 1 critical test, 1 passed, 0 failed
    robot-test_1  | 1 test total, 1 passed, 0 failed
    robot-test_1  | ==============================================================================
    robot-test_1  | Tests.Test                                                            | PASS |
    robot-test_1  | 4 critical tests, 4 passed, 0 failed
    robot-test_1  | 4 tests total, 4 passed, 0 failed
    robot-test_1  | ==============================================================================
    robot-test_1  | Tests                                                                 | PASS |
    robot-test_1  | 4 critical tests, 4 passed, 0 failed
    robot-test_1  | 4 tests total, 4 passed, 0 failed
    robot-test_1  | ==============================================================================
    robot-test_1  | Output:  /robot/report/output.xml
    robot-test_1  | Log:     /robot/report/log.html
    robot-test_1  | Report:  /robot/report/report.html
    ct_robot-test_1 exited with code 0
    Aborting on container exit...
    /Projects/FROSO/ufp-env-handlebars-docker
    Starting Test Stack End 0
    ------------------------------------------------------------------------------
    Shutting down Infrastructure 
    ------------------------------------------------------------------------------
    Stack.sh called
    SCRIPT_PATH=/Projects/FROSO/ufp-env-handlebars-docker/stack.sh
    SCRIPT_NAME=stack.sh
    SCRIPT_HOME=/Projects/FROSO/ufp-env-handlebars-docker/
    START=0
    STOP=1
    STACK_INFRA=0
    STACK_DEBUG=0
    STACK_SERVICE=1
    STACK_TEST=0
    CREATE=0
    Stopping Service Stack
    Stopping ct_ufp-env-handlebars_1  ... done
    Stopping ct_ufp-env-handlebars2_1 ... done
    Removing ct_ufp-env-handlebars_1  ... done
    Removing ct_ufp-env-handlebars2_1 ... done
    Removing network ct_default
    /Projects/FROSO/ufp-env-handlebars-docker
    Stopping Service Stack End
    EXITING WITH 0
