# clone repo
git clone https://github.com/vfarcic/cloud-provisioning.git

cd cloud-provisioning

# swarm with 3 managers
scripts/dm-swarm.sh

# Notes:
# better with as least 3 managers (best with odd number, ie leader selection)

# switch to swarm-1 env
eval $(dm env swarm-1)

# show list of docker nodes
docker node ls