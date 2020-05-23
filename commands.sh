
# Format volumes
sudo mkfs.ext4 /dev/vdb

# Mount volumes
sudo mount /dev/vdb /mnt –t auto

# Unmount volumes
sudo umount /mnt



export declare -a nodes=(docker-1 docker-2 docker-3)
export masternode=`echo ${nodes} | cut -f1 -d' '`
export declare -a othernodes=`echo ${nodes[@]} | sed s/${masternode}//`
export size=${#nodes[@]}
export user=admin
export pass=admin
export VERSION='3.0.0'
export cookie='a192aeb9904e6590849337933b000c99'
export uuid='a192aeb9904e6590849337933b001159'

docker pull ibmcom/couchdb3:${VERSION}

#on each aurin node

if [ ! -z $(docker ps --all --filter "name=couchdb${node}" --quiet) ] 
    then
        docker stop $(docker ps --all --filter "name=couchdb${node}" --quiet) 
        docker rm $(docker ps --all --filter "name=couchdb${node}" --quiet)
fi 

docker create\
      --name couchdb${node}\
      --env COUCHDB_USER=${user}\
      --env COUCHDB_PASSWORD=${pass}\
      --env COUCHDB_SECRET=${cookie}\
      --env ERL_FLAGS="-setcookie \"${cookie}\" -name \"couchdb@${node}\""\
      ibmcom/couchdb3:${VERSION}

docker create\
      --name couchdb-docker-2\
      -p 5984:5984/tcp\
      --env COUCHDB_USER=${user}\
      --env COUCHDB_PASSWORD=${pass}\
      --env COUCHDB_SECRET=${cookie}\
      --env ERL_FLAGS="-setcookie \"${cookie}\" -name \"couchdb@docker-2\""\
      ibmcom/couchdb3:${VERSION}


curl -XPOST "http://${user}:${pass}@115.146.93.189:5984/_cluster_setup"\
      --header "Content-Type: application/json"\
      --data "{\"action\": \"add_node\", \"host\":\"${node}\",\
             \"port\": \"5984\", \"username\": \"${user}\", \"password\":\"${pass}\"}"

