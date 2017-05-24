# add label env=prod-like to test node
docker node update \
  --label-add env=prod-like \
  swarm-test-2

# inspect label
docker node inspect --pretty swarm-test-2

# label to test node 3
docker node update \
  --label-add env=prod-like \
  swarm-test-3

# create util service on a prod.like node
docker service create --name util \
  --constraint 'node.labels.env == prod.like' \
  alpine sleep 1000000

# scale it x6
docker service scale util=6

docker service ps util

# create util-2 in global mode
docker service create --name util-2 \
  --mode global \
  --constraint 'node.labels.env == prod.like' \
  alpine sleep 1000000