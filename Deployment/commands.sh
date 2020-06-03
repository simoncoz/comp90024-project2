
# 2020 COMP90024 Project2
# This is a scratchpad of commands for the project. Not for execution in whole.
# Simon Cozens 1071589
# Solmaz Maabi 871603
# Wenkang Dang 1009151

# Format volumes
mkfs.ext4 /dev/vdb

# Mount volumes
mount /dev/vdb /mnt –t auto

# Unmount volumes
umount /mnt

# Set proxy in /etc/environment 

 HTTP_PROXY="http://wwwproxy.unimelb.edu.au:8000/"
 HTTPS_PROXY="http://wwwproxy.unimelb.edu.au:8000/"
 http_proxy="http://wwwproxy.unimelb.edu.au:8000/"
 https_proxy="http://wwwproxy.unimelb.edu.au:8000/"
 no_proxy="localhost,127.0.0.1,localaddress,172.16.0.0/12,.melbourne.rc.nectar.org.au,.storage.unimelb.edu.au,.cloud.unimelb.edu.au"

# Add proxy to docker daemon config to enable access to external registries. 
# https://docs.docker.com/config/daemon/systemd/

sudo mkdir /etc/systemd/system/docker.service.d
sudo nano /etc/systemd/system/docker.service.d/http-proxy.conf

[Service]
Environment="HTTP_PROXY=http://wwwproxy.unimelb.edu.au:8000/" "HTTPS_PROXY=http://wwwproxy.unimelb.edu.au:8000/" "http_proxy=http://wwwproxy.unimelb.edu.au:8000/" "https_proxy=http://wwwproxy.unimelb.edu.au:8000/" "no_proxy=localhost,127.0.0.1,localaddress,172$"

# Flush & restart
sudo systemctl daemon-reload
sudo systemctl restart docker

## Install depenencies
sudo apt update
sudo apt upgrade

sudo apt -y install python3-pip
sudo pip3 install tweepy
sudo pip3 install couchdb
sudo apt install jq

### Install Couchdb

# Set env variables on each node for cluster setup
export declare -a nodes=(172.26.131.226 172.26.130.128 172.26.130.232)
export masternode=`echo ${nodes} | cut -f1 -d' '`
export declare -a othernodes=`echo ${nodes[@]} | sed s/${masternode}//`
export size=${#nodes[@]}
export user=admin
export pass=group49xxx
export VERSION='3.0.0'
export cookie='a192aeb9904e6590849337933b000c99'
export uuid='a192aeb9904e6590849337933b001159'

docker pull ibmcom/couchdb3:${VERSION}

# Run on node 1
export node=172.26.131.226
docker create\
      --name couchdb${node}\
      -p 4369:4369\
      -p 5984:5984\
      -p 9100-9200:9100-9200\
      -v /mnt/home/couchdb/data:/opt/couchdb/data \
      --env COUCHDB_USER=${user}\
      --env COUCHDB_PASSWORD=${pass}\
      --env COUCHDB_SECRET=${cookie}\
      --env ERL_FLAGS="-setcookie \"${cookie}\" -name \"couchdb@${node}\""\
      apache/couchdb



# Run on node 2
export node=172.26.130.128
docker create\
      --name couchdb${node}\
       -p 4369:4369\
      -p 5984:5984\
      -p 9100-9200:9100-9200\
      -v /mnt/home/couchdb/data:/opt/couchdb/data \
      --env COUCHDB_USER=${user}\
      --env COUCHDB_PASSWORD=${pass}\
      --env COUCHDB_SECRET=${cookie}\
      --env ERL_FLAGS="-setcookie \"${cookie}\" -name \"couchdb@${node}\""\
      apache/couchdb

docker start

curl -XPOST "http://${user}:${pass}@${masternode}:5984/_cluster_setup" \
      --header "Content-Type: application/json"\
      --data "{\"action\": \"enable_cluster\", \"bind_address\":\"${node}\",\
             \"username\": \"${user}\", \"password\":\"${pass}\", \"port\": \"5984\",\
             \"remote_node\": \"${node}\", \"node_count\": \"$(echo ${nodes[@]} | wc -w)\",\
             \"remote_current_user\":\"${user}\", \"remote_current_password\":\"${pass}\"}"

curl -XPOST "http://${user}:${pass}@${masternode}:5984/_cluster_setup"\
      --header "Content-Type: application/json"\
      --data "{\"action\": \"add_node\", \"host\":\"${node}\",\
             \"port\": \"5984\", \"username\": \"${user}\", \"password\":\"${pass}\"}"

# Run on node 3
export node=172.26.130.232
docker create\
      --name couchdb${node}\
      -p 4369:4369\
      -p 5984:5984\
      -p 9100-9200:9100-9200\
      -v /mnt/home/couchdb/data:/opt/couchdb/data \
      --env COUCHDB_USER=${user}\
      --env COUCHDB_PASSWORD=${pass}\
      --env COUCHDB_SECRET=${cookie}\
      --env ERL_FLAGS="-setcookie \"${cookie}\" -name \"couchdb@${node}\""\
      apache/couchdb

curl -XPOST "http://${user}:${pass}@${masternode}:5984/_cluster_setup" \
      --header "Content-Type: application/json"\
      --data "{\"action\": \"enable_cluster\", \"bind_address\":\"${node}\",\
             \"username\": \"${user}\", \"password\":\"${pass}\", \"port\": \"5984\",\
             \"remote_node\": \"${node}\", \"node_count\": \"$(echo ${nodes[@]} | wc -w)\",\
             \"remote_current_user\":\"${user}\", \"remote_current_password\":\"${pass}\"}"

curl -XPOST "http://${user}:${pass}@${masternode}:5984/_cluster_setup"\
      --header "Content-Type: application/json"\
      --data "{\"action\": \"add_node\", \"host\":\"${node}\",\
             \"port\": \"5984\", \"username\": \"${user}\", \"password\":\"${pass}\"}"

# Finish cluster setup on node 1 (but can be any node)

# This empty request is to avoid an error message when finishing the cluster setup 
curl -XGET "http://${user}:${pass}@${masternode}:5984/"

curl -XPOST "http://${user}:${pass}@${masternode}:5984/_cluster_setup"\
    --header "Content-Type: application/json" --data "{\"action\": \"finish_cluster\"}"

export declare -a nodes=(172.26.131.226 172.26.130.128 172.26.130.232)
for node in "${nodes[@]}"; do  curl -X GET "http://${user}:${pass}@${node}:5984/_membership"; done


# Add database to any node
export newdb="tweetsdb"
curl -XPUT "http://${user}:${pass}@${masternode}:5984/${newdb}"
for node in "${nodes[@]}"; do  curl -X GET "http://${user}:${pass}@${node}:5984/_all_dbs"; done


