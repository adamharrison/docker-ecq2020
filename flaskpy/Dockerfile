FROM python:3-alpine
LABEL maintainer="P.M. Campbell" email="pcampbell.edu@gmail.com"

RUN pip install --no-cache-dir Flask

COPY hello.py /usr/local/bin/hello.py 

# default flask port
EXPOSE 5000

# working dir
WORKDIR /usr/local/bin

# runtime
CMD [ "python", "./hello.py" ] 
