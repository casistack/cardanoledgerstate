# cardanoledgerstate Downloads
This was created to help those who have limited memory on their cardano-node and therefore downloading the ledger state (cardano-cli query ledger-state --mainnet --out-file ledger.json) sometimes exhausts resources on nodes. 
It's can also help in theautomation to check leader logs in combination with Andrews cncli application https://github.com/AndrewWestberg/cncli/blob/develop/USAGE.md

Note: This was a quick put together, aka spaghetti code and therefore security and fine tuning has not been taking into consideration . 
I have chosen to use FTP as the server for the ledgerstate uploads, however to make it secure , ftps or ssh using public keys could be used. 
Modify this accordingly to suite your needs.
The comms between all my nodes and transfer is locked down to specific IP's and ports. 

## Automation steps achived

1. using cron , create and start a cardano-node on mainnet
2. check if node has fully synced
3. connect to docker containner and dump ledgerstate
4. connect to ftp server
5.  upload ledgerstate
6.  using cron, node downloads ledger state
7.  Node  then runs leaderlogs checks using cncli an dumps output to json
8.  Leader logs updates my grafana
