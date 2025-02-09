#  pandocker
You don't have to install pandoc, the idea here is to set up a container with a shared volume so that
you can use pandoc from a container.

This is to make it easy to convert their word docs to other formats (ex markdown) maps current working directory to the container so file must be in cwd, and uses either interactive or a config.pandoc file to determine what to convert.

* Uses pandoc core (alpine) as a base image https://hub.docker.com/r/pandoc/core 
* Uses a shared volume to host the file to be converted (ex my.docx) and a config.pandoc file if using.
* Configured with help from https://github.com/pandoc/dockerfiles#basic-usage
* This images is in the docker hub organization [dawsoncollege2020](https://hub.docker.com/u/dawsoncollege2020)
* See the [running it on windows](WINHOWTO.md)
* Uses pandoc core image https://hub.docker.com/r/pandoc/core 

If you use a [config.pandoc](config.pandoc.txt) file to indicate the (no spaces, if in file name use \" \") 
```
IN=filetoread
OUT=filetocreate
TYPE=conversion-type
```
1. input file name
2. output file name
3. output file format

or

4. Instead: a single option to put in the full options see [pandoc](pandoc.org) for full syntax

See the supporting [Dockerfile](Dockerfile) and the  [Makefile](Makefile)

**__Note__** If you are newly learning docker I __strongly__ suggest you use the command line interface as it may be used anywhere: windoze, *nix, and cloud shells.  No need to learn new interfaces every time.

## TL;DR
### To run this app  windows
1. install docker https://docs.docker.com/install/ 
    * on windows Drives are not automatically shared with Docker Desktop so you must change the  settings before you start the container. see [Windows one time prep](WINHOWTO.md#one-time-prep)
2. cd to the directory that holds your doc to convert, & config.pandoc if you're using it.
3. `docker run --rm --volume "%cd%:/data" -ti dawsoncollege2020/pandocker`  

### To run this app  *nix
1. install docker https://docs.docker.com/install/ 
    * on *nix you will need to add your user to the docker group to run as a regular user `sudo usermod -aG docker youruserid`
2. cd to the directory that holds your doc to convert, & config.pandoc if you're using it.
3. `docker run -ti --rm --volume "$(pwd):/data" dawsoncollege2020/pandocker`  

## run time
This image can be run interactively or using a file see example [config.pandoc](full.example.config.pandoc).  If config.pandoc* exists, it will be used, if not it will be interactive, the script will ask for source, destination files and the conversion type. 

* See *nix [runtime example](RUNFROMHUB.md) for complete information.  
* See the [windows how to](WINHOWTO.md) for running on windows

## docker registry image repo
Instructions also in [docker hub for pandocker](https://hub.docker.com/r/dawsoncollege2020/pandocker)
## create & run the container image
You will first have to clone this repo and cd into this directory, the build assumes the Dockerfile is in the current working directory. check the [Makefile](Makefile) for version info etc.
1. `make build`
2. `make run`
### docker commands
see  [common docker commands](../docker-usage-overview/DOCKERCMDS.md) 
### docker-compose commands
see  [common docker commands](../docker-usage-overview/DOCKERCOMPOSECMDS.md)


