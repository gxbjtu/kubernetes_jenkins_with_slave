# kubernetes_jenkins_with_slave
Jenkins master and slave on kubernetes

1. build master image and push to your docker hub
2. build slave image and push to your docker hub
3. create nfs storage and deploy [kube-pre](kube/kube-pre.yml)
4. deploy [kube-jenkins-master](kube/kube-jenkins-master.yml)
5. init jenkins master, install plugins
6. create slave node in jenkins node management, and then deploy [kube-jenkins-slave](kube/kube-jenkins-slave.yml) with slave node info

