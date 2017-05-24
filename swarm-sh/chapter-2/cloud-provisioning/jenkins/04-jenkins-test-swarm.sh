# create test swarm
scripts/dm-test-swarm.sh

# switch to swarm-test-1 env
eval $(dm env swarm-test-1)

docker node ls

docker node inspect swarm-test-1 --pretty

# ssh into swarm-test-1
dm ssh swarm-test-1

# create /workspace folder with full permissions (777)
sudo mkdir /workspace && sudo chmod 777 /workspace && exit
