# dockerfile for apache + php for  php 2019 assignment2
# 2020-2-29	

FROM php:7.2-apache
LABEL maintainer="P Campbell" email="pcampbell.edu@gmail.com" modified="2020-02-29"

# env var for apt-get otherwise I get the TERM not set error
ENV DEBIAN_FRONTEND noninteractive

# install updates
RUN apt-get -y update && apt-get clean 
# install mysql necessaries
RUN docker-php-ext-install mysqli pdo pdo_mysql

WORKDIR /var/www/html/

# install app
# note for test purposes it is being run from local disk, see yaml
#COPY app.tgz .
#RUN tar -xzf app.tgz ; rm app.tgz ; mv app/* . ; rm -rf app .git

# expose the website port
EXPOSE 80

# launch apache   (systemctl not installed on this image )
CMD apachectl -D  FOREGROUND
