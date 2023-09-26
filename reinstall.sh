
#!/bin/bash
cat << "EOF"


	  /$$$$$$                                          /$$                 /$$         /$$
	 /$$__  $$                                        |__/                | $$       /$$$$
	| $$  \__/  /$$$$$$  /$$$$$$$   /$$$$$$   /$$$$$$$ /$$  /$$$$$$$      | $$      |_  $$
	| $$ /$$$$ /$$__  $$| $$__  $$ /$$__  $$ /$$_____/| $$ /$$_____/      | $$        | $$	
	| $$|_  $$| $$$$$$$$| $$  \ $$| $$$$$$$$|  $$$$$$ | $$|  $$$$$$       | $$        | $$
	| $$  \ $$| $$_____/| $$  | $$| $$_____/ \____  $$| $$ \____  $$      | $$        | $$
	|  $$$$$$/|  $$$$$$$| $$  | $$|  $$$$$$$ /$$$$$$$/| $$ /$$$$$$$/      | $$$$$$$$ /$$$$$$
	 \______/  \_______/|__/  |__/ \_______/|_______/ |__/|_______/       |________/|______/


	 /$$   /$$ /$$$$$$$$  /$$$$$$  /$$       /$$$$$$ /$$$$$$$$ /$$   /$$ /$$$$$$  /$$$$$$ 
	| $$$ | $$| $$_____/ /$$__  $$| $$      |_  $$_/|__  $$__/| $$  | $$|_  $$_/ /$$__  $$
	| $$$$| $$| $$      | $$  \ $$| $$        | $$     | $$   | $$  | $$  | $$  | $$  \__/
	| $$ $$ $$| $$$$$   | $$  | $$| $$        | $$     | $$   | $$$$$$$$  | $$  | $$      
	| $$  $$$$| $$__/   | $$  | $$| $$        | $$     | $$   | $$__  $$  | $$  | $$      
	| $$\  $$$| $$      | $$  | $$| $$        | $$     | $$   | $$  | $$  | $$  | $$    $$
	| $$ \  $$| $$$$$$$$|  $$$$$$/| $$$$$$$$ /$$$$$$   | $$   | $$  | $$ /$$$$$$|  $$$$$$/
	|__/  \__/|________/ \______/ |________/|______/   |__/   |__/  |__/|______/ \______/ 


	 /$$$$$$$$                   
	| $$_____/                   
	| $$        /$$$$$$  /$$$$$$ 
	| $$$$$    /$$__  $$|____  $$
	| $$__/   | $$  \__/ /$$$$$$$ 
	| $$      | $$      /$$__  $$
	| $$$$$$$$| $$     |  $$$$$$$
	|________/|__/      \_______/
                             
                             
                                                                                                                                                                                                                                                                                            
                                                                                                                                                                                                                             	 
	Welcome to the decentralized blockchain Renaissance, above money & beyond cryptocurrency!
	This script should install genesis_29-2 blockchain full node while running under root user.
	GENESIS L1 is a highly experimental decentralized project, provided AS IS, with NO WARRANTY.
	GENESIS L1 IS A NON COMMERCIAL OPEN DECENRALIZED BLOCKCHAIN PROJECT RELATED TO SCIENCE AND ART
          
  Mainnet EVM chain ID: 29
  Cosmos chain ID: genesis_29-2
  Blockchain utilitarian coin: L1
  Min. coin unit: el1
  1 L1 = 1 000 000 000 000 000 000 el1 	
  Initial supply: 21 000 000 L1
  genesis_29-2 circulation: ~22 000 000 L1
  Mint rate: < 20% annual
  Block target time: ~5s
  Binary name: genesisd
  genesis_29-1 start: Nov 30, 2021
  genesis_29-2 start: Apr 16, 2022
EOF
sleep 15s

# SYSTEM UPDATE, INSTALLATION OF THE FOLLOWING PACKAGES: jq git wget make gcc build-essential snapd wget ponysay, INSTALLATION OF GO 1.17 via snap

sudo apt-get update -y
sudo apt-get install jq git wget make gcc build-essential snapd wget -y
snap install --channel=1.20/stable go --classic
export PATH=$PATH:$(go env GOPATH)/bin
echo 'export PATH=$PATH:$(go env GOPATH)/bin' >> ~/.bashrc

# GLOBAL CHANGE OF OPEN FILE LIMITS
echo "* - nofile 50000" >> /etc/security/limits.conf
echo "root - nofile 50000" >> /etc/security/limits.conf
echo "fs.file-max = 50000" >> /etc/sysctl.conf 
ulimit -n 50000

#PONYSAY 
snap install ponysay
sleep 5s
ponysay "BE READY TO WRITE DOWN AND REMEMBER YOUR NEW SECRET SEED PHRASE GENERATED WITH THIS SCRIPT FOR YOUR NEW KEY NAMED *mygenesiskey* AND PASSWORDS FOR IT"
sleep 5s
ponysay "Installing genesisd from source code with updated genesis_29-2 mainnet!"
sleep 5s
ponysay "WARNING: cosmosvisor, evmosd processes will be killed and genesis, genesisd, evmos, evmosd system services will be stopped with this script on the next step. If you have other blockchains running, you might want to delete those parts of the script!"
sleep 20s

#STOPPING EVMOSD DAEMON AND COSMOVISOR IF IT WAS NOT STOPPED
pkill evmosd
pkill cosmovisor
service genesis stop
service genesisd stop
service evmos stop
service evmosd stop

# BACKUP PREVIOUS .genesisd
cd
rsync -r --verbose --exclude 'data' ./.genesisd/ ./.genesisd_backup/

# DELETING OF .genesisd FOLDER (PREVIOUS INSTALLATIONS)
cd 
rm -r .genesisd

# BUILDING genesisd BINARIES
cd genesisd
make install
export PATH=$PATH:$(go env GOPATH)/bin
echo 'export PATH=$PATH:$(go env GOPATH)/bin' >> ~/.bashrc

# SETTING CONFIG AND NEW KEYS
genesisd config chain-id genesis_29-2
genesisd config keyring-backend os

ponysay "IN A FEW MOMENTS GET READY TO WRITE YOUR SECRET SEED PHRASE FOR YOUR NEW KEY NAMED *mygenesiskey*, YOU WILL HAVE 2 MINUTES FOR THIS!!!"
sleep 20s
genesisd keys add mygenesiskey --keyring-backend os --algo eth_secp256k1
sleep 120s

genesisd init $1 --chain-id genesis_29-2 

#IMPORTING THE GENESIS STATE
cd 
cd .genesisd/config
rm -r genesis.json
wget https://github.com/alpha-omega-labs/genesisd/raw/neolithic/genesis_29-1-state/genesis.json
cd

# RESET TO IMPORTED genesis.json
genesisd unsafe-reset-all

# ADD PEERS, ADJUST SETTINGS
cd 
cd .genesisd/config
sed -i 's/seeds = ""/seeds = ""/' config.toml
sed -i 's/persistent_peers = ""/persistent_peers = "4197dcaabbbf9f6047f6dd56f90d86c66b8113bb@162.55.97.214:26656,3e64e0a3a701ce36d6dbe207e908428c38303796@212.154.25.24:26656"/' config.toml
sed -i 's/minimum-gas-prices = "0aphoton"/minimum-gas-prices = "0el1"/g' app.toml
sed -i '212s/.*/enable = false/' app.toml
# STARTING genesisd AS A SERVICE
 cd
 cd /etc/systemd/system
 rm -r genesis.service
 # wget https://raw.githubusercontent.com/alpha-omega-labs/genesisd/neolithic/genesisd.service
 # systemctl daemon-reload
 # systemctl enable genesisd.service
 echo All set! 

# service genesisd start
# genesisd start
ponysay "start genesisd daemon, set stop height before it`"
