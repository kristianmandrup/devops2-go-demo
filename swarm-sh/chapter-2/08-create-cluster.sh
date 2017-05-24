# remove 3 nodes
dm rm -f node-1 node-2 node-3

# remove nodes 1..3
for i in 1 2 3; do
  dm rm -f node-$i
done

# create virtual boxes
for i in 1 2 3; do
  docker-machine create -d virtualbox node-$i
done

# switch to node 1
eval $(dm env node-1)

# add swarm, advertised via node1
docker swarm init --advertise-addr $(dm ip node-1)

# create token used to init new worker
TOKEN=$(docker swarm join-token -q worker)

# add workers node-2 and node-3
for i in 2 3; do
  eval $(dm env node-$i)
  docker swarm join \
    --token $TOKEN \
    --advertise-addr $(dm ip node-$i) \
    $(dm ip node-1):2377
done

# switch env to node-1
eval $(dm env node-1)

docker node ls

