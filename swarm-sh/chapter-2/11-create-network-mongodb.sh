docker network create --driver overlay go-demo

docker service create --name go-demo-db --network go-demo mongo:3.2.10