git clone https://github.com/vfarcic/cloud-provisioning.git

cd cloud-provisioning

scripts/dm-swarm.sh

eval $(docker-machine env swarm-1)

docker node ls

curl -o docker-compose-proxy.yml \
    https://raw.githubusercontent.com/\
vfarcic/docker-flow-proxy/master/docker-compose.yml

cat docker-compose-proxy.yml

export DOCKER_IP=$(docker-machine ip swarm-1)

docker-compose -f docker-compose-proxy.yml \
    up -d consul-server

curl -X PUT -d 'this is a test' \
    http://$(docker-machine ip swarm-1):8500/v1/kv/msg1

curl http://$(docker-machine ip swarm-1):8500/v1/kv/msg1

curl http://$(docker-machine ip swarm-1):8500/v1/kv/msg1?raw

cat docker-compose-proxy.yml

export CONSUL_SERVER_IP=$(docker-machine ip swarm-1)

for i in 2 3; do
    eval $(docker-machine env swarm-$i)

    export DOCKER_IP=$(docker-machine ip swarm-$i)

    docker-compose -f docker-compose-proxy.yml \
        up -d consul-agent
done

curl http://$(docker-machine ip swarm-2):8500/v1/kv/msg1

curl -X PUT -d 'this is another test' \
    http://$(docker-machine ip swarm-2):8500/v1/kv/messages/msg2

curl -X PUT -d 'this is a test with flags' \
    http://$(docker-machine ip swarm-3):8500/v1/kv/messages/msg3?flags=1234

curl http://$(docker-machine ip swarm-1):8500/v1/kv/?recurse

curl -X DELETE http://$(docker-machine ip swarm-2):8500/v1/kv/?recurse

curl http://$(docker-machine ip swarm-3):8500/v1/kv/?recurse

eval $(docker-machine env swarm-1)

docker network create --driver overlay proxy

docker service create --name proxy \
    -p 80:80 \
    -p 443:443 \
    -p 8080:8080 \
    --network proxy \
    -e MODE=swarm \
    --replicas 3 \
    -e CONSUL_ADDRESS="$(docker-machine ip swarm-1):8500,$(docker-machine ip swarm-2):8500,$(docker-machine ip swarm-3):8500" \
    vfarcic/docker-flow-proxy

docker service ps proxy

docker network create --driver overlay go-demo

docker service create --name go-demo-db \
    --network go-demo \
    mongo:3.2.10

docker service create --name go-demo \
    -e DB=go-demo-db \
    --network go-demo \
    --network proxy \
    vfarcic/go-demo:1.0

curl "$(docker-machine ip swarm-1):8080/v1/docker-flow-proxy/reconfigure?serviceName=go-demo&servicePath=/demo&port=8080"

curl "$(docker-machine ip swarm-1):8080/v1/docker-flow-proxy/reconfigure?serviceName=go-demo&servicePath=/demo&port=8080&distribute=true"

curl -i $(docker-machine ip swarm-1)/demo/hello

NODE=$(docker service ps proxy | grep "proxy.3" | awk '{print $4}')

eval $(docker-machine env $NODE)

ID=$(docker ps | grep "proxy.3" | awk '{print $1}')

docker exec -it $ID cat /cfg/haproxy.cfg

docker service create --name util \
    --network proxy --mode global \
    alpine sleep 1000000000

docker service ps util

ID=$(docker ps -q --filter label=com.docker.swarm.service.name=util)

docker exec -it $ID apk add --update drill

docker exec -it $ID drill proxy

docker exec -it $ID drill tasks.proxy

curl http://$(docker-machine ip swarm-1):8500/v1/kv/docker-flow?recurse

docker service scale proxy=6

NODE=$(docker service ps proxy | grep "proxy.6" | awk '{print $4}')

eval $(docker-machine env $NODE)

ID=$(docker ps | grep "proxy.6" | awk '{print $1}')

docker exec -it $ID cat /cfg/haproxy.cfg

eval $(docker service ps -f desired-state=Running proxy | \
    tail -n 1 | \
    awk '{print "docker-machine ssh "$4" docker rm -f "$2"."$1}')

NODE=$(docker service ps -f desired-state=running proxy | grep "proxy.6" | awk '{print $4}')

eval $(docker-machine env $NODE)

ID=$(docker ps | grep "proxy.6" | awk '{print $1}')

docker exec -it $ID cat /cfg/haproxy.cfg

docker-machine rm -f swarm-1 swarm-2 swarm-3