#!/bin/bash

JENKINS_IMAGE=your_docker_registry/jenkins:v2.60.3

docker build -t ${JENKINS_IMAGE} -f Dockerfile .
docker push ${JENKINS_IMAGE}

# if you want to use docker/kubectl command in jenkins, you should run like this:
docker run -p 8080:8080 -p 50000:50000 --name jenkins \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v /usr/bin/docker:/usr/bin/docker \
    -v /usr/lib64/libltdl.so.7:/usr/lib/x86_64-linux-gnu/libltdl.so.7 \
    -v /usr/bin/kubectl:/usr/bin/kubectl \
    ${JENKINS_IMAGE}