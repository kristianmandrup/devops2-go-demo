# requst for all keys starting with docker-flow
curl "http://$(dm ip swarm-1):8500/v1/kv/docker-flow?recurse"

# scale 6x proxy service
docker service scale proxy=6

# find node for proxy #6
NODE=$(docker service ps proxy | grep "proxy.6" | awk '{print $4}')

eval $(dm env $NODE)

ID=$(docker ps | grep "proxy.6" | awk '{print $1}')

docker exec -it $ID cat /cfg/haproxy.cfg

# destroy instance to see failover
docker rm -f $(docker ps | grep "proxy.6" | awk '{print $1}')

#
NODE=$(docker service ps -f desired-state=running proxy | grep "proxy.6" | awk '{print $1}')

eval $(dm env $NODE)

ID=$(docker ps | grep "proxy.6" | awk '{print $1}')

docker exec -it $ID cat /cfg/haproxy.cfg

# destroy swarm
dm rm -f swarm-1 swarm-2 swarm-3
