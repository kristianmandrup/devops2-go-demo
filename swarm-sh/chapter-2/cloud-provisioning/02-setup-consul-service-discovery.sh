# Get docker-compose-proxy.yml
curl -o docker-compose-proxy.yml \
  https://raw.githubusercontent.com/vfarcic/docker-flow-proxy/master/docker-compose.yml

# get swarm IP
export DOCKER_IP=$(dm ip swarm-1)

# compose consul-server
docker-compose -f docker-compose-proxy.yml up -d consul-server

# test it: put value
curl -X PUT -d 'this is a test' "http://$(dm ip swarm-1):8500/v1/kv/msg1"

# get value back
curl "http://$(dm ip swarm-1):8500/v1/kv/msg1"
