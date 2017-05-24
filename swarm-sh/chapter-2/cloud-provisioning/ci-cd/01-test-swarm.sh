scripts/dm-swarm.sh

eval $(dm env swarm-1)

# create registry service (production cluster)
docker service create --name registry \
  -p 5000:5000 \
  --reserve-memory 100m \
  --mount "type=bind,source=$PWD,target=/var/lib/registry" \
  registry:2.5.0

docker node ls

# Create test swarm
scripts/dm-test-swarm.sh

# switch to swarm-test environment
eval $(dm env swarm-test-1)

# list test nodes :)
docker node ls

# create registry service in test/CD cluster
docker service create --name registry \
  -p 5000:5000 \
  --reserve-memory 100m \
  --mount "type=bind,source=$PWD,target=/var/lib/registry" \
  registry:2.5.0

