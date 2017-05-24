# create agent service
export USER=admin
export PASSWORD=admin

docker service create --name jenkins-agent \
  -e COMMAND_OPTIONS="-master \
  http://$(dm ip swarm-1):8082/jenkins \
  -username $USER -password $PASSWORD \
  -labels 'docker' -executors 5" \
  --mode global \
  --constraint 'node.labels.env == jenkins-agent' \
  --mount "type=bind,source=/var/run/docker.sock,target=/var/run/docker.sock" \
  --mount "type=bind,source=$HOME/.docker/machine/machines,target=/machines" \
  --mount "type=bind,source=/workspace,target=/workspace" \
  vfarcic/jenkins-swarm-agent

# Broken!?
# docker service ps jenkins-agent

docker service inspect jenkins-agent

open "http://$(dm ip swarm-1):8082/jenkins/computer"