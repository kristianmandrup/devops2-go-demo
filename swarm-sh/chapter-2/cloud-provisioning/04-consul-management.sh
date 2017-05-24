eval $(dm env swarm-1)

# create overlay proxy network for Consul
docker network create --driver overlay proxy

# run proxy Consul service (service registry as a "swarm")
docker service create --name proxy \
  -p 80:80 \
  -p 443:443 \
  -p 8080:8080 \
  --network proxy \
  --replicas 3 \
  -e MODE=swarm \
  -e CONSUL_ADDRESS="$(dm ip swarm-1):8500,$(dm ip swarm-2):8500,$(dm ip swarm-3):8500" \
  vfarcic/docker-flow-proxy

# the proxy process
# docker service ps proxy
docker service ps proxy

# create overlay network for go-demo
docker network create --driver overlay go-demo

# create go-demo-db mongo service on go-demo network
docker service create --name go-demo-db \
  --network go-demo \
  mongo:3.2.10

# create go-demo service on go-demo
docker service create --name go-demo \
  -e DB=go-demo-db \
  --network go-demo \
  --network proxy \
  vfarcic/go-demo:1.0

# BAD request
curl "$(dm ip swarm-1):8080/v1/docker-flow-proxy/reconfigure?service\
Name=go-demo&servicePath=/demo&port=8080"

# GOOD Re-configure request
curl "$(dm ip swarm-1):8080/v1/docker-flow-proxy/reconfigure?service\
Name=go-demo&servicePath=/demo&port=8080&distribute=true"

# confirm it works
curl -i "$(dm ip swarm-1)/demo/hello"

# find node
NODE=$(docker service ps proxy | grep "proxy.3" | awk '{print $4}')

# switch client
eval $(dm env $NODE)

ID=$(docker ps | grep "proxy.3" | awk '{print $1}')

# enter node
docker exec -it $ID cat /cfg/haproxy.cfg

# create util service (for drill)
docker service create --name util \
  --network proxy --mode global \
  alpine sleep 10000000

# find node ID
ID=$(docker ps -q --filter label=com.docker.swarm.service.name=util)

# install drill
docker exec -it $ID apk add --update drill

# run drill
docker exec -it $ID drill proxy

# Find IPs of all instances of the service
docker exec -it $ID drill tasks.proxy

