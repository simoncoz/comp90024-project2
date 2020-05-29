# Ubuntu 18.04 (Bionic): Run the following commands:

The INTERNAL IP addresses of each node:
1) 172.26.133.138 
2) 172.26.131.221 
3) 172.26.133.235

#Install erlang

$ sudo apt install erlang-base     
$ sudo apt install erlang-base-hipe

# Install couchdb

$ sudo apt-get install -y apt-transport-https gnupg ca-certificates
$ echo "deb https://apache.bintray.com/couchdb-deb bionic main" \
    | sudo tee -a /etc/apt/sources.list.d/couchdb.list


# Debian/Ubuntu: First, install the CouchDB repository key:

$ sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys \
  8756C4F765C9AC3CB6B85D62379CE192D401AB61

# Then update the repository cache and install the package:

$ sudo apt update
$ sudo apt install -y couchdb

# Cluster setup
https://docs.couchdb.org/en/stable/setup/cluster.html#setup-cluster

## Open ports on security groups

Port Number	Protocol	Recommended binding	Usage
5984	tcp	As desired, by default localhost	Standard clustered port for all HTTP API requests
4369	tcp	All interfaces by default	Erlang port mapper daemon (epmd)
Random above 1024 (see below)	tcp	Automatic

Open etc/vm.args, on all nodes, and add -kernel inet_dist_listen_min 9100 and -kernel inet_dist_listen_max 9200 like below:

-name ...
-setcookie ...
...
-kernel inet_dist_listen_min 9100
-kernel inet_dist_listen_max 9100

## Test Erlang

# On server 1:
erl -name bus@172.26.133.138 -setcookie 'brumbrum' -kernel inet_dist_listen_min 9100 -kernel inet_dist_listen_max 9100

# On server 2
erl -name car@172.26.131.221  -setcookie 'brumbrum' -kernel inet_dist_listen_min 9100 -kernel inet_dist_listen_max 9100

# Back on server 1
net_kernel:connect_node(car@172.26.131.221).

# Notes
2.2.3. Preparing CouchDB nodes to be joined into a cluster
Before you can add nodes to form a cluster, you must have them listening on an IP address accessible from the other nodes in the cluster. You should also ensure that a few critical settings are identical across all nodes before joining them.

The settings we recommend you set now, before joining the nodes into a cluster, are:

etc/vm.args settings as described in the previous two sections
At least one server administrator user (and password)
Bind the node’s clustered interface (port 5984) to a reachable IP address
A consistent UUID. The UUID is used in identifying the cluster when replicating. If this value is not consistent across all nodes in the cluster, replications may be forced to rewind the changes feed to zero, leading to excessive memory, CPU and network use.
A consistent httpd secret. The secret is used in calculating and evaluating cookie and proxy authentication, and should be set consistently to avoid unnecessary repeated session cookie requests.
As of CouchDB 3.0, steps 4 and 5 above are automatically performed for you when using the setup API endpoints described below.

If you use a configuration management tool, such as Chef, Ansible, Puppet, etc., then you can place these settings in a .ini file and distribute them to all nodes ahead of time. Be sure to pre-encrypt the password (cutting and pasting from a test instance is easiest) if you use this route to avoid CouchDB rewriting the file.