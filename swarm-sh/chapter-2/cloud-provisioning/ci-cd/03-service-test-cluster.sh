# test swar with prod-like labels added
scripts/dm-test-swarm-services.sh

eval $(dm env swarm-test-1)

# send request to go-demo in test swarm
curl -i "$(dm ip swarm-test-1)/demo/hello"

# create same swarm of services in production cluster
scripts/dm-swarm-services.sh

eval $(dm env swarm-1)

docker service ls


