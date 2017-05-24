# create mongo DB service
docker service create --name go-demo-db mongo:3.2.10

# inspect service
docker service inspect --pretty go-demo-db