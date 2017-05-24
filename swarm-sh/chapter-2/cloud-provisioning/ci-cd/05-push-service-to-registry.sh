# tag for local registry v.1.1
docker tag go-demo localhost:5000/go-demo:1.1

# push v.1.1 to local registry localhost:5000,
docker push localhost:5000/go-demo:1.1

# test if service go-demo is running
docker service ps go-demo -f desired-state=running

# upgrade service to v.1.1
docker service update \
  --image=localhost:5000/go-demo:1.1 \
  go-demo

# test updated service running
docker service ps go-demo -f desired-state=running

# YES!!!

export HOST_IP=localhost

# run on production: swarm-test-1 node
docker-compose -f docker-compose-test-local-no-extends.yml \
  run --rm production

# remove all swarm nodes
for i in 1 2 3; do
  dm rm -f swarm-$i
  dm rm -f swarm-test-$i
done
