# Makefile with explanations
## Imported by the Makefile 
see the `include config.make`

```
CONTAINER_IMAGE=tricia/shakespeare-ec
RUN_NAME=shakespeare-ec
HOST_PORT=8800
CONTAINER_PORT=80
GIT_REPO=git@github.com:campbe13/ecq2020-shakespeare-ec.git
DOCKER_REPO=$CONTAINER_IMAGE
```
## Makefile target syntax 
This is a generic target entry, to use it `make target`
```
# comment
# (note: the <tab> in the command line is necessary for make to work) 
target:  dependency1 dependency2 ...
      <tab> command
```
## Makefile

```
# Makefile to build docker image & push to hub.docker.com
# ref https://www.cs.swarthmore.edu/~newhall/unixhelp/howto_makefiles.html
# helpful https://gist.github.com/mpneuried/0594963ad38e68917ef189b4e6a269db
# pmcampbell
# 2020-2-19 / 2020-2-21

include config.make
#export $(shell sed 's/=.*//' $(cnf))
```
### target to show help `make help`
```
# .PHONY used if no options given
.PHONY: help
help: ## put help info here
	@echo Makefile for container $(RUN_NAME) 
	@echo clone: $(GIT_REPO)
	@echo build: $(CONTAINER_IMAGE) 
	@echo run: $(RUN_NAME)
	@echo port forward on run container:$(CONTAINER_PORT) to host:$(HOST_PORT)	
```
### target  to clone & package the repo, build assumes the app is in a tarball `./app.tgz``

```
# clone (need keys, or interactive w uid/pass)
clone: ## 	clone
	if [ -d app ] ; then  rm -rf app; fi
	mkdir app;  git clone $(GIT_REPO) app
	tar -czf app.tgz app
```
### target to build docker image, if we use a compiled language will need more builds
``` 
build: ##   build container image from Dockerfile
	docker build -t $(CONTAINER_IMAGE) . 
```
### target to run the container image: alternate run, omits `-d`  so console has control of console, logs to stdout
```
run-fg:  ## run the container logs to stdout
	docker run -p $(HOST_PORT):$(CONTAINER_PORT) --name $(RUN_NAME)  $(CONTAINER_IMAGE)
```
### target to run the container image, detach `-d` then show running docker containers `ps`
```
run:  ## run the container detached (~in the background )
	docker run -d -p $(HOST_PORT):$(CONTAINER_PORT) --name $(RUN_NAME)  $(CONTAINER_IMAGE)
	docker ps 
```
### target to shell into the app sh or shell
```
sh:	shell
shell:  ## shell into the container
	docker exec -ti $(RUN_NAME) sh
```
### combinations of targets, run sequentially
```
all: clone build run
up:  build run

clean:  stop prune
stoprun: stop run
```
### target for testing stop & remove running container
```
stop: ## stop and remove the container
	docker stop $(RUN_NAME) ; docker rm $(RUN_NAME) ; docker ps
```
### target to use at the end of testing usee to clean up the intermediary images
```
prune:  # clean up unused containers
	docker system prune -f
	docker images
```
### target to check if docker is running & what version
```
check:  ## check docker run time
	@echo to end sytemctl, hit q
	systemctl status  docker
	docker version
	docker images
	docker ps
```
### target to push your code to docker hub
```
publish:   
	@echo publish to  docker hub, interactive 
        ifdef DOCKER_USER
		docker login   -u $(DOCKER_USER)
        else
		docker login 
        endif
	docker image push $(CONTAINER_IMAGE):latest
```
### target to push your code to heroku registry  & release it 
```
heroku: ## using heroku commands
	@echo interactive login to heroku
	heroku login -i 
	@echo create app on heroku 
	heroku create $(RUN_NAME) 
	@echo push to the heroku repo
	heroku container:push web --app $(RUN_NAME)
	@echo release app
	heroku container:release web --app $(RUN_NAME)
	@echo if the last step worked load https://$(RUN_NAME).herokuapp.com in a browser
```
### testing docker commands to publish to heroku, not working 2020-02-27
#### internal script
```
define tokenfile =
fn=heroku-auth-token.txt
heroku auth:token >> $fn
TOKEN=$(cat $fn)
endef 
# needed for bash script
# https://www.gnu.org/software/make/manual/html_node/One-Shell.html
.ONESHELL:
```
#### target, not working 
```
heroku-via-docker:  	## use heroku cli to generate token
	$(tokenfile)
	docker login --username=_ -- password=$(TOKEN) registry.heroku.com
	docker build -t registry.heroku.com/$(RUN_NAME)/web .
	docker push registry.heroku.com/$(RUN_NAME)/web
```
