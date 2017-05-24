# create overlay proxy network
docker network create --driver overlay proxy

# list nodes in overlay network
docker network ls -f "driver=overlay"