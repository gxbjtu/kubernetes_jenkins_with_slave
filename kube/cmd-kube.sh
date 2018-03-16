#!/bin/bash

# run as root
sudo su
export JENKINS_VOLUME=/home/jenkins/master
mkdir ${JENKINS_VOLUME}
chown -R 1000 ${JENKINS_VOLUME}
chgrp -R 1000 ${JENKINS_VOLUME}
echo "${JENKINS_VOLUME} *(insecure,rw,async,no_root_squash)" >> /etc/exports
systemctl restart nfs
# end run as root

export JENKINS_VOLUME=/home/jenkins/master
export NFS_SERVER=your_nfs_storage_address
export JENKINS_IMAGE=your_docker_registry/jenkins:v2.60.3
export JENKINS_SERVER_PORT=30002
export JENKINS_TUNNEL_PORT=30003

sed -i 's@${JENKINS_VOLUME}@'"$JENKINS_VOLUME"'@' *.yml
sed -i 's@${NFS_SERVER}@'"$NFS_SERVER"'@' *.yml
sed -i 's@${JENKINS_IMAGE}@'"$JENKINS_IMAGE"'@' *.yml
sed -i 's@${JENKINS_SERVER_PORT}@'"$JENKINS_SERVER_PORT"'@' *.yml
sed -i 's@${JENKINS_TUNNEL_PORT}@'"$JENKINS_TUNNEL_PORT"'@' *.yml

kubectl apply -f kube-pre.yml --record
kubectl apply -f kube-jenkins-master.yml --record



export JENKINS_AGENT_VOLUME=/home/jenkins/agent
sudo mkdir ${JENKINS_AGENT_VOLUME}
sudo chown -R 1000 ${JENKINS_AGENT_VOLUME}
sudo chgrp -R 1000 ${JENKINS_AGENT_VOLUME}


export JENKINS_MASTER_HOST=your_jenkins_master_host
export JENKINS_SLAVE_IMAGE=your_docker_registry/jenkins/jnlp-slave:v3.16
export JENKINS_URL=http://${JENKINS_MASTER_HOST}:${JENKINS_SERVER_PORT}
export JENKINS_TUNNEL=${JENKINS_MASTER_HOST}:${JENKINS_TUNNEL_PORT}
export JENKINS_AGENT_NAME=your_agent_name[jenkins_node_manager]
export JENKINS_SECRET=your_agent_secret[jenkins_node_manager]

sed -i 's@${JENKINS_SLAVE_IMAGE}@'"$JENKINS_SLAVE_IMAGE"'@' *.yml
sed -i 's@${JENKINS_URL}@'"$JENKINS_URL"'@' *.yml
sed -i 's@${JENKINS_TUNNEL}@'"$JENKINS_TUNNEL"'@' *.yml
sed -i 's@${JENKINS_AGENT_NAME}@'"$JENKINS_AGENT_NAME"'@' *.yml
sed -i 's@${JENKINS_SECRET}@'"$JENKINS_SECRET"'@' *.yml
sed -i 's@${JENKINS_AGENT_VOLUME}@'"$JENKINS_AGENT_VOLUME"'@' *.yml

kubectl apply -f kube-jenkins-slave.yml --record

