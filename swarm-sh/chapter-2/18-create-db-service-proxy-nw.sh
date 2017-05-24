# create service go-demo on networks:
# - go-demo, proxy
# link to db: go-demo-db
docker service create --name go-demo \
  -e DB=go-demo-db \
  --network go-demo \
  --network proxy \
  vfarcic/go-demo:1.0