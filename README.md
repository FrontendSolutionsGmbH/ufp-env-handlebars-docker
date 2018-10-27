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
	

# How To Use this Image

## Default Template Syntax

The included template renders a json data containing these properties:

	{
	
	menu:[
	{
	label
	link
	target
	color
	children
	}
	
	]
	welcome:{
	entries: [
		alerts:[{
			text,
			color
			}],
		text:[{
			title,
			text,
			color
		}],
		buttons:[{
			label,
			description,
			link ,
			target,
			color
		}]   	
	]}
	
	}

To fill the data, the environment is used to fill it, when starting the container each environment variable with the syntax

	CFG_PROPERTY1_PROPERTY2=value
	
are configured to fill the data json object provided to handlebars, see component tests for example

## Mount Volumes

## Config

the mount position for the config is 

	/ufp-env-handlebars/static/config

the config location consist of 2 files:

* default.json - this file defines the default values, merged with env
* getjsondata.sh - this is a shell script that you could use to generate more sophisticated input, it returns a json structure to the standard output, which is picked up and forwarded to the template .callback data field

## Templates
                        
the mount position for the template folder is 

	/ufp-env-handlebars/static/template
	
all files found in this folder are transpiled using a handlebars renderer and stored in the web root and hosted, so keep a index.html in your file system as entry point
	

## Default Callback

A callback feature enables you to provide an own script to render some additional json, e.g. a `docker info` command it is called on container startup - will be called regularly in future versions




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
