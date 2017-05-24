# create proxy service with 3 ports: 80, 443 (ssh) and 8080
# - network: proxy, mode = swarm (deployed to swarm cluster)
docker service create --name proxy \
  -p 80:80 \
  -p 443:443 \
  -p 8080:8080 \
  --network proxy \
  -e MODE=swarm \
  vfarcic/docker-flow-proxy

# the proxy process
docker service ps proxy
