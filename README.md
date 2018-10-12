# ufp-env-handlebars-docker
UFP Docker image that creates a JSON from ENV variables, and feeds them to a Handlebars template

WARNING:
this is work in progress, and dockerized version will include only bundled files, current state is using copied node modules folder untouched in image



# Quickstart

# Install node dependencies 

for now you have to install the node modules manually, this will be replaced with a webpack/rollup bundler to
get rid of huge node modules folder

# Build docker

build the docker file using the 

	./build.sh
	
