# remove existing swarm nodes
for i in 1 2 3; do
  dm rm -f swarm-$i
done

for i in 1 2 3; do
  dm rm -f swarm-test-$i
done


# swarm with 3 managers
scripts/dm-swarm.sh

# switch to swarm-1 env
eval $(dm env swarm-1)

# show list of docker nodes
docker node ls

mkdir -p docker/jenkins

docker service create --name jenkins \
  -p 8082:8080 \
  -p 5000:5000 \
  -e JENKINS_OPTS="--prefix=/jenkins" \
  --mount "type=bind,source=$PWD/docker/jenkins,target=/var/jenkins_home" \
  --reserve-memory 300m \
  jenkins:2.7.4-alpine

# check jenkins process
docker service ps jenkins

open "http://$(dm ip swarm-1):8082/jenkins"

# get initial password
cat docker/jenkins/secrets/initialAdminPassword

# Login
# kmandrup/Jer...