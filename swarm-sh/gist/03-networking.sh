for i in 1 2 3; do
  docker-machine create -d virtualbox node-$i
done

eval $(docker-machine env node-1)

docker swarm init \
  --advertise-addr $(docker-machine ip node-1)

TOKEN=$(docker swarm join-token -q worker)

for i in 2 3; do
  eval $(docker-machine env node-$i)

  docker swarm join \
    --token $TOKEN \
    --advertise-addr $(docker-machine ip node-$i) \
    $(docker-machine ip node-1):2377
done

eval $(docker-machine env node-1)

docker node ls

docker service create --name go-demo-db \
  mongo:3.2.10

docker service inspect --pretty go-demo-db

docker service rm go-demo-db

docker network create --driver overlay go-demo

docker service create --name go-demo-db \
  --network go-demo \
  mongo:3.2.10

docker service inspect --pretty go-demo-db

docker service create --name util \
    --network go-demo --mode global \
    alpine sleep 1000000000

docker service ps util

ID=$(docker ps -q --filter label=com.docker.swarm.service.name=util)

docker exec -it $ID apk add --update drill

docker exec -it $ID drill go-demo-db

docker network create --driver overlay proxy

docker network ls -f "driver=overlay"

docker service create --name go-demo \
  -e DB=go-demo-db \
  --network go-demo \
  --network proxy \
  vfarcic/go-demo:1.0

docker service create --name proxy \
    -p 80:80 \
    -p 443:443 \
    -p 8080:8080 \
    --network proxy \
    -e MODE=swarm \
    vfarcic/docker-flow-proxy

docker service ps proxy

curl "$(docker-machine ip node-1):8080/v1/docker-flow-proxy/reconfigure?serviceName=go-demo&servicePath=/demo&port=8080"

curl -i $(docker-machine ip node-1)/demo/hello

curl -i $(docker-machine ip node-3)/demo/hello

NODE=$(docker service ps proxy | tail -n +2 | awk '{print $4}')

eval $(docker-machine env $NODE)

ID=$(docker ps -q --filter "ancestor=vfarcic/docker-flow-proxy")

docker exec -it \
    $ID cat /cfg/haproxy.cfg

eval $(docker-machine env node-1)

docker service scale go-demo=5

ID=$(docker ps -q --filter label=com.docker.swarm.service.name=util)

docker exec -it $ID apk add --update drill

docker exec -it $ID drill go-demo

docker-machine rm -f node-1 node-2 node-3