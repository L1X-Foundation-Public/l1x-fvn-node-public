# L1X FVN Node Setup Guide

## Useful Links:
- YouTube Tutorial: [Watch the Setup Guide on YouTube](https://www.youtube.com/watch?v=rVmyP-yaMTA)
- GitHub Wiki: [Visit the GitHub Wiki for Detailed Documentation](https://github.com/L1X-Foundation-Public/l1x-fvn-node-public/wiki)
- 
## System Requirements:
- Operating System: Linux (recommended), MacOS
- RAM: 8GB Minimum
- Storage: 100 GB Minimum
- CPU: 4 CPU/vCPU min
- Docker: Version 24.0.7 or higher, build afdd53b
- Docker Compose: Version 1.29 or higher

## Prerequisites:
Ensure that you have Git, Docker and Docker Compose installed on your system:

### Step 0: Git Clone the repository

```
git clone git@github.com:L1X-Foundation-Public/l1x-fvn-node-public.git
cd l1x-fvn-node
```

### Step 1: Docker and Docker Compose Installation
  
#### Docker Installation:
- Visit the Docker documentation for installation instructions: [https://docs.docker.com/get-docker/](https://docs.docker.com/get-docker/)

#### Docker Compose Installation:
- Visit the Docker Compose documentation for installation instructions: [https://docs.docker.com/compose/install/](https://docs.docker.com/compose/install/)

#### Post Installation:
- To run Docker without root privileges: [https://docs.docker.com/engine/install/linux-postinstall/](https://docs.docker.com/engine/install/linux-postinstall/)

### Step 2: Generate L1X Artifact (Config and Docker Compose file) :

Give executable permission to 'generateArtifact.sh'

```
sudo chmod +x generateArtifact.sh
./generateArtifact.sh
```

Run 'generateArtifact.sh' to Generate L1X Artifact such as config.toml and docker-compose.yml necessary to start the node


- **Default L1X DB Port : 5432**

### Step 3: Configure L1X-Node Credentials  :

Assign Valid L1X Node Credentials **Private Key (without 0x Prefix), Address (without 0x Prefix) and FVN Identifier** without 0x Prefix in **config.toml** file

While replacing keep with double quotation

```
node_private_key = "<REPLACE_NODE_PRIVATE_KEY>"
node_address = "<REPLACE_NODE_ADDRESS>"
fvn_uuid = "<REPLACE_FVN_UUID>"

```

To find FVN Identifier from Link : https://l1xapp.com/node-operator/node-schedule


### Step 4: Kickstart L1X-Node :

Provide Executable Permission and Run Executable as follows

```
sudo chmod +x startL1X.sh
./startL1X.sh
```

After Starting , Please wait for at least for 1 hour to Complete 


## Directory Structure:
```
.
├── README.md
├── bin
│   ├── commit.log
│   └── l1x-core
├── chain_data
│   └── l1x
│       ├── config.toml
│       └── genesis.json
├── config.toml
├── config.toml.template
├── docker
│   ├── Dockerfile
│   ├── docker-compose.yml
│   ├── docker-compose.yml.template
│   ├── postgresql.conf
│   └── run-server.sh
├── generateArtifact.sh
└── startL1X.sh
```


- **bin**: 
    - **commit.log**: Commit Log file denoting commit-id for binary file release referenced to L1X code base
    - **l1x-core**: Executable file for running the L1X Core.

- **docker**: 
    - **docker-compose.yml**: Docker compose file for L1X Core and L1X Core DB
    - **Dockerfile**: Docker image for running L1X Core .
    - **v2_core_db.conf**: Configuration file for L1X Core DB (Postgres).
    - **run-server.sh**: A shell script that runs the L1X server (Referenced by Docker Container).

- **config.toml**: A configuration file in TOML format for the L1X Core
- **config.toml.template**: A configuration file template in TOML format for the L1X Core (For Reference Only)


- **startL1X.sh**: A shell script that likely starts the L1X application or L1X Core.

## To Tear Down v2_core_server and v2_core_db including chain_data 

Run

```
sudo chmod +x tearDownL1X.sh
sudo ./tearDownL1X.sh

```


## To View Logs 

Run:

```
docker logs -f --tail 10 v2_core_server
```


