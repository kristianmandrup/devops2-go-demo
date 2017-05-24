# create virtual boxes
for i in 1 2 3; do
  docker-machine create -d virtualbox node-$i
done
