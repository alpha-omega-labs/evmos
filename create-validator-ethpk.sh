
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


   	 /$$    /$$          /$$ /$$       /$$             /$$                        
  	| $$   | $$         | $$|__/      | $$            | $$                        
  	| $$   | $$ /$$$$$$ | $$ /$$  /$$$$$$$  /$$$$$$  /$$$$$$    /$$$$$$   /$$$$$$ 
  	|  $$ / $$/|____  $$| $$| $$ /$$__  $$ |____  $$|_  $$_/   /$$__  $$ /$$__  $$
   	\  $$ $$/  /$$$$$$$| $$| $$| $$  | $$  /$$$$$$$  | $$    | $$  \ $$| $$  \__/
    	 \  $$$/  /$$__  $$| $$| $$| $$  | $$ /$$__  $$  | $$ /$$| $$  | $$| $$      
     	  \  $/  |  $$$$$$$| $$| $$|  $$$$$$$|  $$$$$$$  |  $$$$/|  $$$$$$/| $$      
      	   \_/    \_______/|__/|__/ \_______/ \_______/   \___/   \______/ |__/      
                                                                                                                                                       +                                                                                                                                                                                                                                                                                                                                                 
                                                                                                                                                                                                                             	 
	Welcome to the decentralized blockchain Renaissance, above money & beyond cryptocurrency!
	This script should create genesis_29-2 blockchain validator while running under root user,
  	Using some Ethereum format private key with some amount of L1 belonging to that key.
  	Should be started after the full node sync, for example after genesisd-node.sh script run.
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



ponysay "This script will create your new GenesisL1 validator. You should run this script on fully synchronized node. For example after the genesisd-node.sh script run. You can check status of your node service with:
service genesisd status"

cat << "EOF"
This script should be running with arguments:
-YOUR_VALIDATOR_NAME
-YOUR_PRIVATE_KEY (please, use NEW keys to avoid issues!!!)
-AMOUNT_EL1_STAKED (nominated in el1, 1L1 = 1,000,000,000,000,000,000el1)
-COMMISSION_RATE(0.01 = 1%; 0.99 = 99%)

Example that will create validator named "supervalidator" with 1000L1 self stake and 10% commission:
sh create-validator.sh supervalidator 58a86862565e596bcf185d699ef4db6a8f02f6696f4a3fe6ff5cf5c0b451c866 1000000000000000000000 0.1
EOF
sleep 15s
ponysay "Be ready to submit new password to encrypt your key and remember it."
sleep 5s
cd
cd go
cd bin
ponysay "Importing your Ethereum key"
sleep 3s
./genesisd keys unsafe-import-eth-key importedethkey $2 --keyring-backend os
sleep 2s
ponysay "Submitting create validator transaction, enter your key password"
./genesisd tx staking create-validator \
  --amount=$3el1 \
  --pubkey=$(genesisd tendermint show-validator) \
  --moniker="$1" \
  --chain-id=genesis_29-2 \
  --commission-rate="$4" \
  --commission-max-rate="0.99" \
  --commission-max-change-rate="0.01" \
  --min-self-delegation="1000000" \
  --gas="2100000" \
  --from=importedethkey \
  --fees=4200000000000000el1 \
  --broadcast-mode async \
  -y

