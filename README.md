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


	$ ./test.sh 
    [2018-10-18 14:27:16] ------------------------------------------------------------------------------
    [2018-10-18 14:27:16] Bringing up Infrastructure 
    [2018-10-18 14:27:16] ------------------------------------------------------------------------------
    [2018-10-18 14:27:16] Stack.sh called
    [2018-10-18 14:27:16] SCRIPT_PATH=/Projects/ufp-env-handlebars-docker/stack.sh
    [2018-10-18 14:27:16] SCRIPT_NAME=stack.sh
    [2018-10-18 14:27:16] SCRIPT_HOME=/Projects/ufp-env-handlebars-docker/
    [2018-10-18 14:27:16] START=0
    [2018-10-18 14:27:16] STOP=1
    [2018-10-18 14:27:16] STACK_INFRA=0
    [2018-10-18 14:27:16] STACK_DEBUG=0
    [2018-10-18 14:27:16] STACK_SERVICE=1
    [2018-10-18 14:27:16] STACK_TEST=0
    [2018-10-18 14:27:16] CREATE=1
    [2018-10-18 14:27:16] Stopping Service Stack
    [2018-10-18 14:27:16] ------------------------------------------------------------------------------
    [2018-10-18 14:27:16] Building ufp-env-handlebars 
    [2018-10-18 14:27:16] ------------------------------------------------------------------------------
    [2018-10-18 14:27:16] ------------------------------------------------------------------------------
    [2018-10-18 14:27:16] Building ufp-env-handlebars docker file 
    [2018-10-18 14:27:16] ------------------------------------------------------------------------------
    Sending build context to Docker daemon  1.247MB
    Step 1/10 : FROM node:8-slim as builder
    8-slim: Pulling from library/node
    795df959b1e6: Pull complete 
    56c7020e9265: Pull complete 
    02415c59bfcb: Pull complete 
    b94195c82796: Pull complete 
    595fff18a493: Pull complete 
    Digest: sha256:9e701e4b0900d25d06c33c99654034c3bd6aa4406da8b895688cabef136144ad
    Status: Downloaded newer image for node:8-slim
     ---> c136029ee5fc
    Step 2/10 : ENV PATH ${PATH}:/ufp-env-handlebars-build/node_modules/.bin
     ---> Running in 29f6d422bf80
    Removing intermediate container 29f6d422bf80
     ---> d10bdd801916
    Step 3/10 : COPY js/ /ufp-env-handlebars-build
     ---> 48a2743e3126
    Step 4/10 : WORKDIR /ufp-env-handlebars-build/js
     ---> Running in 4b21acf7092d
    Removing intermediate container 4b21acf7092d
     ---> 8d0e8646d5c2
    Step 5/10 : RUN yarn install
     ---> Running in 0285195c3300
    yarn install v1.9.4
    [1/4] Resolving packages...
    [2/4] Fetching packages...
    info fsevents@1.2.4: The platform "linux" is incompatible with this module.
    info "fsevents@1.2.4" is an optional dependency and failed compatibility check. Excluding it from installation.
    [3/4] Linking dependencies...
    [4/4] Building fresh packages...
    success Saved lockfile.
    Done in 14.40s.
    Removing intermediate container 0285195c3300
     ---> e07308d6afbe
    Step 6/10 : FROM node:8-slim
     ---> c136029ee5fc
    Step 7/10 : COPY --from=builder /ufp-env-handlebars-build /ufp-env-handlebars
     ---> ed2ad13b3074
    Step 8/10 : WORKDIR /ufp-env-handlebars
     ---> Running in 01ab21c42c42
    Removing intermediate container 01ab21c42c42
     ---> 548cd7521ffa
    Step 9/10 : EXPOSE 3000:3000
     ---> Running in b5d80c742571
    Removing intermediate container b5d80c742571
     ---> 14d07c508aa1
    Step 10/10 : CMD ./execute.sh
     ---> Running in 8aaa473afa4e
    Removing intermediate container 8aaa473afa4e
     ---> 37fa22f62aca
    Successfully built 37fa22f62aca
    Successfully tagged ckleinhuis/ufp-env-handlebars:3
    [2018-10-18 14:27:57] ------------------------------------------------------------------------------
    [2018-10-18 14:27:57] Building finished 
    [2018-10-18 14:27:57] ------------------------------------------------------------------------------
    [2018-10-18 14:27:57] ------------------------------------------------------------------------------
    [2018-10-18 14:27:57] docker run  -p 3000:3000 ufp/env-handlebars 
    [2018-10-18 14:27:57] ------------------------------------------------------------------------------
    ufp-env-handlebars uses an image, skipping
    ufp-env-handlebars2 uses an image, skipping
    Removing network ct_default
    WARNING: Network ct_default not found.
    /Projects/ufp-env-handlebars-docker
    [2018-10-18 14:27:57] Stopping Service Stack End
    [2018-10-18 14:27:57] Stack.sh exit
    [2018-10-18 14:27:57] Stack.sh called
    [2018-10-18 14:27:57] SCRIPT_PATH=/Projects/ufp-env-handlebars-docker/stack.sh
    [2018-10-18 14:27:57] SCRIPT_NAME=stack.sh
    [2018-10-18 14:27:57] SCRIPT_HOME=/Projects/ufp-env-handlebars-docker/
    [2018-10-18 14:27:57] START=1
    [2018-10-18 14:27:57] STOP=0
    [2018-10-18 14:27:57] STACK_INFRA=0
    [2018-10-18 14:27:57] STACK_DEBUG=0
    [2018-10-18 14:27:57] STACK_SERVICE=1
    [2018-10-18 14:27:57] STACK_TEST=0
    [2018-10-18 14:27:57] CREATE=0
    [2018-10-18 14:27:57] Starting Service Stack
    Creating network "ct_default" with the default driver
    Pulling ufp-env-handlebars (ckleinhuis/ufp-env-handlebars:latest)...
    latest: Pulling from ckleinhuis/ufp-env-handlebars
    795df959b1e6: Already exists
    56c7020e9265: Already exists
    02415c59bfcb: Already exists
    b94195c82796: Already exists
    595fff18a493: Already exists
    d858327b707d: Pull complete
    Digest: sha256:ea2d7ee428bac77c9680000f87ecc70f3b45b8de89265276ba6a447202f8c937
    Status: Downloaded newer image for ckleinhuis/ufp-env-handlebars:latest
    Creating ct_ufp-env-handlebars_1  ... done
    Creating ct_ufp-env-handlebars2_1 ... done
    /Projects/ufp-env-handlebars-docker
    [2018-10-18 14:28:04] Returning Service Stack
    [2018-10-18 14:28:04] Stack.sh exit
    [2018-10-18 14:28:04] ------------------------------------------------------------------------------
    [2018-10-18 14:28:04] Executing component test 
    [2018-10-18 14:28:04] ------------------------------------------------------------------------------
    [2018-10-18 14:28:04] Stack.sh called
    [2018-10-18 14:28:04] SCRIPT_PATH=/Projects/ufp-env-handlebars-docker/stack.sh
    [2018-10-18 14:28:04] SCRIPT_NAME=stack.sh
    [2018-10-18 14:28:04] SCRIPT_HOME=/Projects/ufp-env-handlebars-docker/
    [2018-10-18 14:28:04] START=0
    [2018-10-18 14:28:04] STOP=1
    [2018-10-18 14:28:04] STACK_INFRA=0
    [2018-10-18 14:28:04] STACK_DEBUG=0
    [2018-10-18 14:28:04] STACK_SERVICE=0
    [2018-10-18 14:28:04] STACK_TEST=1
    [2018-10-18 14:28:04] CREATE=1
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
     ---> Running in d3c4a727b6bc
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
      Downloading https://files.pythonhosted.org/packages/56/9d/1d02dd80bc4cd955f98980f28c5ee2200e1209292d5f9e9cc8d030d18655/certifi-2018.10.15-py2.py3-none-any.whl (146kB)
    Building wheels for collected packages: robotframework-requests
      Running setup.py bdist_wheel for robotframework-requests: started
      Running setup.py bdist_wheel for robotframework-requests: finished with status 'done'
      Stored in directory: /root/.cache/pip/wheels/ca/9d/f3/2e457eb9e49f328c2e9f1bfaa467df9bf54b42524c92d21af6
    Successfully built robotframework-requests
    Installing collected packages: idna, chardet, urllib3, certifi, requests, robotframework-requests
    Successfully installed certifi-2018.10.15 chardet-3.0.4 idna-2.7 requests-2.19.1 robotframework-requests-0.4.7 urllib3-1.23
    You are using pip version 10.0.1, however version 18.1 is available.
    You should consider upgrading via the 'pip install --upgrade pip' command.
    Removing intermediate container d3c4a727b6bc
     ---> 75dc685340ad
    Step 3/5 : VOLUME /robot/tests
     ---> Running in d750a36ec4d3
    Removing intermediate container d750a36ec4d3
     ---> e9b65593bb23
    Step 4/5 : VOLUME /robot/report
     ---> Running in 627c6d18d624
    Removing intermediate container 627c6d18d624
     ---> c948f78c6649
    Step 5/5 : ENTRYPOINT [ "robot", "-d", "/robot/report", "/robot/tests"]
     ---> Running in 0b31f1fe3459
    Removing intermediate container 0b31f1fe3459
     ---> eac9089a7bc3
    Successfully built eac9089a7bc3
    Successfully tagged ct_robot-test:latest
    WARNING: Found orphan containers (ct_ufp-env-handlebars2_1, ct_ufp-env-handlebars_1) for this project. If you removed or renamed this service in your compose file, you can run this command with the --remove-orphans flag to clean it up.
    Removing network ct_default
    ERROR: network ct_default id fc660b5d87416610152e1e4664447b71140b8b4ed3bcad69613e9f3311ecd723 has active endpoints
    /Projects/ufp-env-handlebars-docker
    [2018-10-18 14:28:18] Stack.sh exit
    [2018-10-18 14:28:18] Stack.sh called
    [2018-10-18 14:28:18] SCRIPT_PATH=/Projects/ufp-env-handlebars-docker/stack.sh
    [2018-10-18 14:28:18] SCRIPT_NAME=stack.sh
    [2018-10-18 14:28:18] SCRIPT_HOME=/Projects/ufp-env-handlebars-docker/
    [2018-10-18 14:28:18] START=1
    [2018-10-18 14:28:18] STOP=0
    [2018-10-18 14:28:18] STACK_INFRA=0
    [2018-10-18 14:28:18] STACK_DEBUG=0
    [2018-10-18 14:28:18] STACK_SERVICE=0
    [2018-10-18 14:28:18] STACK_TEST=1
    [2018-10-18 14:28:18] CREATE=0
    WARNING: Found orphan containers (ct_ufp-env-handlebars2_1, ct_ufp-env-handlebars_1) for this project. If you removed or renamed this service in your compose file, you can run this command with the --remove-orphans flag to clean it up.
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
    /Projects/ufp-env-handlebars-docker
    [2018-10-18 14:28:19] Starting Test Stack End 0
    [2018-10-18 14:28:19] Stack.sh exit
    [2018-10-18 14:28:19] ------------------------------------------------------------------------------
    [2018-10-18 14:28:19] Shutting down Infrastructure 
    [2018-10-18 14:28:19] ------------------------------------------------------------------------------
    [2018-10-18 14:28:19] Stack.sh called
    [2018-10-18 14:28:19] SCRIPT_PATH=/Projects/ufp-env-handlebars-docker/stack.sh
    [2018-10-18 14:28:19] SCRIPT_NAME=stack.sh
    [2018-10-18 14:28:19] SCRIPT_HOME=/Projects/ufp-env-handlebars-docker/
    [2018-10-18 14:28:19] START=0
    [2018-10-18 14:28:19] STOP=1
    [2018-10-18 14:28:19] STACK_INFRA=0
    [2018-10-18 14:28:19] STACK_DEBUG=0
    [2018-10-18 14:28:19] STACK_SERVICE=1
    [2018-10-18 14:28:19] STACK_TEST=0
    [2018-10-18 14:28:19] CREATE=0
    [2018-10-18 14:28:19] Stopping Service Stack
    Stopping ct_ufp-env-handlebars2_1 ... done
    Stopping ct_ufp-env-handlebars_1  ... done
    Removing ct_ufp-env-handlebars2_1 ... done
    Removing ct_ufp-env-handlebars_1  ... done
    Removing network ct_default
    /Projects/ufp-env-handlebars-docker
    [2018-10-18 14:28:30] Stopping Service Stack End
    [2018-10-18 14:28:30] Stack.sh exit
    [2018-10-18 14:28:30] EXITING WITH 0
