docker service create --name util \
  --network go-demo --mode global \
  alpine sleep 10000000
