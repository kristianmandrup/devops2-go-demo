# find jenkins node name
NODE=$(docker service ps \
  -f desired-state=running jenkins \
  | tail -n +2 | awk '{print $4}')

# switch env to jenkins node
eval $(dm env $NODE)

# get jenkins image name
IMAGE=$(docker ps \
  | grep jenkins \
  | awk '{print $2}')

# remove image
docker rm -f $(docker ps -qa \
  -f "ancestor=$IMAGE")

# check fail over restart
docker service ps jenkins

# reopen
open "http://$(dm ip swarm-1):8082/jenkins"


