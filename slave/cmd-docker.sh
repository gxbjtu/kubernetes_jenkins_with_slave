#!/bin/bash

JENKINS_SLAVE_IMAGE=your_docker_registry/jenkins/jnlp-slave:v3.16

docker build -t ${JENKINS_SLAVE_IMAGE} -f Dockerfile .
docker push ${JENKINS_SLAVE_IMAGE}

# if you want to use docker/kubectl command in jenkins, you should run like this:
export JENKINS_SERVER_PORT=30002
export JENKINS_TUNNEL_PORT=30003
export JENKINS_MASTER_HOST=your_jenkins_master_host
export JENKINS_SLAVE_IMAGE=your_docker_registry/jenkins/jnlp-slave:v3.16
export JENKINS_URL=http://${JENKINS_MASTER_HOST}:${JENKINS_SERVER_PORT}
export JENKINS_TUNNEL=${JENKINS_MASTER_HOST}:${JENKINS_TUNNEL_PORT}
export JENKINS_AGENT_NAME=docker-builder
export JENKINS_SECRET=

docker run --name jenkins-slave \
    -e JENKINS_SECRET=${JENKINS_SECRET} -e JENKINS_AGENT_NAME=${JENKINS_AGENT_NAME} \
    -e JENKINS_URL=${JENKINS_URL} -e JENKINS_TUNNEL=${JENKINS_TUNNEL} \
    -e JNLP_PROTOCOL_OPTS=-Dorg.jenkinsci.remoting.engine.JnlpProtocol3.disabled=false \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v /usr/bin/docker:/usr/bin/docker \
    -v /usr/lib64/libltdl.so.7:/usr/lib/x86_64-linux-gnu/libltdl.so.7 \
    -v /usr/bin/kubectl:/usr/bin/kubectl \
    ${JENKINS_SLAVE_IMAGE}