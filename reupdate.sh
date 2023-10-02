
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

                                                                                                                                                            
                                                                                                                                                                                                                             	 
	Welcome to the decentralized blockchain Renaissance, above money & beyond cryptocurrency!
	This script should reupdate genesis_29-2 to genesis_29-2 while running under root user.
	GENESIS L1 is a highly experimental decentralized project, provided AS IS, with NO WARRANTY.
	GENESIS L1 IS A NON COMMERCIAL OPEN DECENRALIZED BLOCKCHAIN PROJECT RELATED TO SCIENCE AND ART.
EOF
sleep 5s

sudo apt install sl
sl -F

# SYSTEM UPDATE, INSTALLATION OF THE FOLLOWING PACKAGES: jq git wget make gcc build-essential snapd wget ponysay, INSTALLATION OF GO 1.17 via snap

sudo apt-get update -y
sudo apt-get install jq git wget make gcc build-essential snapd wget -y
snap install --channel=1.20/stable go --classic
export PATH=$PATH:$(go env GOPATH)/bin
echo 'export PATH=$PATH:$(go env GOPATH)/bin' >> ~/.bashrc

# GLOBAL CHANGE OF OPEN FILE LIMITS
echo "* - nofile 50000" >> /etc/security/limits.confnesis_29-2 
echo "root - nofile 50000" >> /etc/security/limits.conf
echo "fs.file-max = 50000" >> /etc/sysctl.conf 
ulimit -n 50000

#PONYSAY 
snap install ponysay
ponysay "Installing genesisd from source code with updated genesis_29-2 mainnet!"
sleep 5s
ponysay "WARNING: cosmosvisor, evmosd processes will be killed and genesis, genesisd, evmos, evmosd system services will be stopped with this script on the next step. If you have other blockchains running, you might want to delete those parts of the script!"
sleep 20s

# STOPPING EVMOSD DAEMON AND COSMOVISOR IF IT WAS NOT STOPPED
pkill evmosd
pkill cosmovisor
service genesis stop
service genesisd stop
service evmos stop
service evmosd stop

# BACKUP .genesisd FOLDER
cd
rsync -r --verbose --exclude 'data' ./.genesisd/ ./.genesisd_backup_reupdate/

# DELETING OF .genesisd FOLDER (PREVIOUS INSTALLATIONS)
cd 
rm -r .genesisd

# BUILDING genesisd BINARIES
cd genesisd
make install

# RESTORE KEYS FROM BACKUP MADE DURING V0.46 UPGRADE - NOTE DATE AFTER _backup_; IF YOU HAVE SEVERAL BACKUPS, USE OLDEST!
# THERE MIGHT BE OLD BACKUP IN DIRECTORY NAMED .evmosd_backup, YOU CAN TRY USE THIS. 
cd
# If evmosd_backup exists, rsync from it
if [ -d ".evmosd_backup" ]; then
    rsync -av --exclude=config/ --exclude=data/ .evmosd_backup/ .genesisd/
else
    # Loop through folders matching the pattern and rsync from them
    for dir in .genesisd_backup_*; do
        if [ -d "$dir" ]; then
            rsync -av --exclude=config/ --exclude=data/ "$dir/" .genesisd/
        fi
    done
fi

# SETTING UP THE NEW chain-id in CONFIG
genesisd config chain-id genesis_29-2

#IMPORTING GENESIS STATE
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
sed -i 's/persistent_peers = ""/persistent_peers = "4197dcaabbbf9f6047f6dd56f90d86c66b8113bb@162.55.97.214:26656,3e64e0a3a701ce36d6dbe207e908428c38303796@212.154.25.24:26656,c23b3d58ccae0cf34fc12075c933659ff8cca200@95.217.207.154:26656,90f6e7509a0024c3ec7188885954b16356757264@168.119.212.118:26656,0a7efe755b2ca413267961ffa62a959c7fd31f45@168.119.138.91:26656,36111b4156ace8f1cfa5584c3ccf479de4d94936@65.21.34.226:26656,907722e9bb60a8dfb553e22b22c403d781ad7295@188.40.110.28:26656,d7d4ea7a661c40305cab84ac227cdb3814df4e43@139.162.195.228:26656,a65bf30b37e11f41422c7fbc0cd4270c0e1e506e@217.13.223.167:56656,060585a1cc1fa88b4188a2d94de07b518dc188cf@144.91.84.196:26656,ef7d81eb8db7ad59b4ce30e022c758cee8dc174f@188.165.202.131:26656,29c638751331a1516e5fb3c8415fc51f84897c55@18.216.81.126:26656,df5fe6b4fafd43c3e7b8c3047fc92e73e4d62ee5@135.181.5.216:26656,62cb81bad72ed77c776c7fec0547b09bdc5ceb22@158.69.253.103:26656,af405a6c392b747aa74704ad0ee8585b8ce164b3@37.187.95.163:26656,0b0e7e460a1c2a4b24293c2d48f8442bc8e85878@198.244.179.62:26651,70c201d6568e0ddf1ebe105df06b957cbc255a8b@46.4.108.77:26656,778ce7aa9b9c497b7a1e3943160652c740e01e7b@192.99.5.160:26656,5b678271fe9835637a1b6a8c370c21c479a7e3f7@185.215.167.123:26656,ade7eba44d652e64d13cd66bded6928cabeb5361@167.235.31.250:26656,eefdbf7eb40265a9e900a10d36de1c088b49420e@144.76.97.251:21496,30a12c1c3a6f72ebc340eaf72ed2a9784e289d8e@161.97.100.28:26656,5082248889f93095a2fd4edd00f56df1074547ba@146.59.81.204:26651,4197dcaabbbf9f6047f6dd56f90d86c66b8113bb@162.55.97.214:26656,698e04b7dc79acbe41991c298cdbc1dc612cc7fc@135.181.73.61:26656,0f9ad819318bfa9735603736aa4c6265f666a7d9@5.135.143.103:26656,80081e9cc1a4370d9cb2b2e37f1b74b583fcbfb3@198.244.228.17:26651,2646a043e1f0c766c5b704463a7d811e100ec7f3@158.69.253.120:26656,ae950870ded893af511bcd98ecdbac9b8e844e91@65.21.205.132:26656,be81a20b7134552e270774ec861c4998fabc2969@5.189.128.191:26656,02bc616c52eaf451468adf7cdbcf67c9fc780ad1@65.108.238.203:36656,e9fa4d00342c753a3600ef384c036e9ab27817eb@159.69.65.97:26656,2d968fbad78775191d0f2389216023dd81641e7c@74.96.207.58:26632,33af0fdb68a200f1e7d570c291817776aeb64c1f@65.108.101.50:60856,999628eae857f75f9f6a0350b8e41f11f04ac044@186.193.241.37:26656,70b41069b2867e4f745eac4c26d6fc7066fa11f2@195.201.165.123:20106,42239bf8f65906324bd5bca22e2d693c125cc012@158.69.253.231:26656,144462f2384d4230f261bb5fd997bd3ce953a6de@192.99.6.11:26656,7757fdee74e8d33ecaa63ead16b3564cb9dea258@85.10.200.11:26656,afe1775a7feb2a1bbfa4d56a6208edb7ed001a83@158.69.253.100:26656,8b5e834a890cdbd840271bc66adb7c913292a76c@154.12.236.9:36656,d4f26df6d1c0ac340683d94ace5691a6d5201dcc@185.252.235.81:26656,3e64e0a3a701ce36d6dbe207e908428c38303796@212.154.25.24:26656,48104213790a9a6cc3dba690619c189e528bee61@172.105.238.169:26656,f2dd060041860c635a45a676a46b9d7027f56e38@185.252.232.74:26641,805caed34b7f0a6fc61fed7126b638ea506f73fd@142.132.202.50:26671"/' config.toml
sed -i 's/minimum-gas-prices = "0aphoton"/minimum-gas-prices = "0el1"/g' app.toml
sed -i 's/halt-height = 0/halt-height = 6751390/g' app.toml
sed -i '212s/.*/enable = false/' app.toml

# STARTING genesisd AS A SERVICE
 cd
 cd /etc/systemd/system
 rm -r genesis.service
 wget https://raw.githubusercontent.com/alpha-omega-labs/genesisd/noobdate/genesisd.service
 systemctl daemon-reload
 systemctl enable genesisd.service
 echo All set! 
 sleep 3s

# STARTING NODE
cat << "EOF"
     	    \\
             \\_
          .---(')
        o( )_-\_
       Node start                                                                                                                                                                                     
EOF
 
sleep 5s
service genesisd start
# genesisd start
ponysay "genesisd node service started, you may try *service genesisd status* command to see it! Welcome to GenesisL1 blockchain!" 
