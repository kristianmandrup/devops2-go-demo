export CONSUL_SERVER_IP=$(dm ip swarm-1)

# compose using consul-agent for nodes: swarm-2 and swarm-3
for i in 2 3; do
  eval $(dm env swarm-$i)
  export DOCKER_IP=$(dm ip swarm-$i)
  docker-compose -f docker-compose-proxy.yml \
    up -d consul-agent
done

docker node ls

# get value from agent
curl "http://$(dm ip swarm-2):8500/v1/kv/msg1"

# COOL :)

# put swarm-2
curl -X PUT -d 'anoter test' "http://$(dm ip swarm-2):8500/v1/kv/messages/msg2"

# put swarm-3 w flag
curl -X PUT -d 'anoter test' "http://$(dm ip swarm-3):8500/v1/kv/messages/msg3?flags=1234"

# get all (recurse)
curl "http://$(dm ip swarm-1):8500/v1/kv/?recurse"

# delete all (recurse)
curl -X DELETE "http://$(dm ip swarm-2):8500/v1/kv/?recurse"

# all gone
curl "http://$(dm ip swarm-3):8500/v1/kv/?recurse"