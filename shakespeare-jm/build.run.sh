#!/bin/bash
# pmc
# 2020-02-12
# see Dockerfile

which docker >/dev/null
if [[ $? -ne 0 ]] ; then
   echo $(basename $0) docker not installed, quitting
   exit 5
fi

# containerimage name
if [[ ! -e CONTAINERNAME ]] ; then
   echo $(basename $0) need a file CONTAINERNAME
   echo -e "$(basename $0) content: \n containerimage=containerimagename \n runname=runtimename"
   exit 4 
fi
source CONTAINERNAME

if [[ $# -eq 0 ]] || [[ $1 != "nobuild" ]] ; then
   read -p "hit enter to build $containerimage"
#  create a tarball of the app 
   tar -czf app.tgz app/
# build the container image
   docker build -t $containerimage .
fi

# run the container
read -p "hit enter to run image $containerimage as $runname"

# stop last runtime
docker stop $runname 2> /dev/null
# run the containerimage
# port forward containerimage 80 to host 8080
# -p hostport:containerimageport  
# detach, run in bg releases console 
# -d 
docker run --name $runname -d -p 8080:80 $containerimage 

# show port bindings 
# docker inspect container
# show running containers
docker ps
