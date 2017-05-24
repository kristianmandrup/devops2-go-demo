# reconfigure proxy
curl "$(dm ip node-1):8080/v1/docker-flow-proxy/reconfigure?serviceName=go-demo&servicePath=/demo&port=8080"

# test service via HTTP url request: hello world
curl -i "$(dm ip node-1)/demo/hello"

# try node 3
curl -i "$(dm ip node-3)/demo/hello"

# get node name of service
NODE=$(docker service ps proxy | tail -n +2 | awk '{print $4}')

# enter service node
eval $(dm env $NODE)

# get ID of proxy container
ID=$(docker ps -q --filter label=com.docker.swarm.service.name=proxy)

# Retrive HAProxy
docker exec -it $ID cat /cfg/haproxy.cfg

# ERROR!?
# could not read CA certificate "/Users/kristianmandrup/.docker/machine/machines/node-1/ca.pem": open /Users/kristianmandrup/.docker/machine/machines/node-1/ca.pem: no such file or directory
