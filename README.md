# GenesisL1

Some fellow and his friends wish to store genetic information as NFTs on a chain.  install and sync this one like this:

bash scripts/statesync.bash






<h2>GenesisL1 fast installation scripts</h2>
root user, tested on clean Ubuntu 20.04 LTS </br>
<li><h3>Update genesis_29-1 to genesis_29-2:</h3>
<code>sh update.sh</code></br>
full command on clean new machine with installed git:</br>
<pre>sudo swapoff -a; git clone https://github.com/alpha-omega-labs/genesisd.git; cd genesisd; sh update.sh</pre>

<li><h3>Install genesis_29-2 full node (suitable for validator):</h3></li>
$YOUR_NEW_NODE_NAME should be changed to any node name you like.</br>
<code>sh genesisd-node.sh $YOUR_NEW_NODE_NAME</code></br>
full command on clean new machine with installed git:</br>
<pre>sudo swapoff -a; git clone https://github.com/alpha-omega-labs/genesisd.git; cd genesisd; sh genesisd-node.sh $YOUR_NEW_NODE_NAME</pre>

<li><h3>Install genesis_29-2 full node with EVM RPC-API enabled (not suitable for validator):</h3></li>
$YOUR_NEW_NODE_NAME should be changed to any node name you like.</br>
<code>sh genesisd-rpc-node.sh $YOUR_NEW_NODE_NAME</code></br>
full command on clean new machine with installed git:</br>
<pre>sudo swapoff -a; git clone https://github.com/alpha-omega-labs/genesisd.git; cd genesisd; sh genesisd-rpc-node.sh $YOUR_NEW_NODE_NAME</pre>

<li><h3>Create validator of genesis_29-2 </h3></li>
<strong>With imported Ethereum private key, with some L1 coins belonging to that key. Start after the genesisd-node.sh and full sync!</strong></br>
<code>sh create-validator-ethpk.sh $YOUR_VALIDATOR_NAME YOUR_PRIVATE_KEY $AMOUNT_EL1_STAKED $COMMISSION_RATE</code></br>
Example to create validator named "supervalidator" with 1000L1 self staked and 10% commission for delegators:</br>
<pre>sh create-validator-ethpk.sh supervalidator 58a86862565e596bcf185d699ef4db6a8f02f6696f4a3fe6ff5cf5c0b451c866 1000000000000000000000 0.1</pre>
