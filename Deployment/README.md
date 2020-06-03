# Deployment

## About
The Ansible playbook to automate the process of creating and deploying VMs, as well as setting up the harvester, couchdb, etc.

## #TODO

Depending on time

- Package the harvester(s) into Docker containers
- Use Docker swarm to define a complete system of couchdb and harvesters
  - Couchdb is one task/service
  - Harvester is another task/service

## How to Run

- Put the _opencr.sh_ file in the working directory.

- Simply play the playbook by running the script: `./run-tweet-harvester.sh`