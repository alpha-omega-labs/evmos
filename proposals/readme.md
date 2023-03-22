<h1>Readme</h1>

+ <h2>genesis-validator-gift-proposal.json</h2> is a template for spending type of proposal for Genesis L1 validators gift of 50,000 L1 coins from the community_pool. It may be edited and submited on chain with genesisd daemon/client. After editing the file with proposal title, description and recipient genesis-validator-gift-proposal.json may be submitted with the following command:
<pre>
genesisd tx gov submit-proposal community-pool-spend genesis-validator-gift-proposal.json
</pre>
