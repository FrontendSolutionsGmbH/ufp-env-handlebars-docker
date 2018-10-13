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

	./build.sh
	

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

# Acknowledgement 

this repository uses a generalization approach for the microservice development, the stack.sh script is used to control
the 4 branches of possible stacks which are:
- Infrastructure - the stack used for everything that is not the service but the service depends on
- Debug - Any debug tools ( like this repository ) that may help yourself keeps track of what is going on
- Service - the service itself, this stack should contain only the service under development
- Test - we use robot framework for testing, nevertheless, the test stack executes against a running infra and service stack


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
