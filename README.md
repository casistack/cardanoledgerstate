# cardanoledgerstate Downloads
This was created to help those who have limited memory on their cardano-nodes and therefore downloading the ledger state (cardano-cli query ledger-state --mainnet --out-file ledger.json) sometimes exhausts resources on nodes. 
It's can also help in the automation to check leader logs in combination with Andrews cncli application https://github.com/AndrewWestberg/cncli/blob/develop/USAGE.md

#### Note: 
This was a quick put together, aka spaghetti code and therefore security and fine tuning has not been taking into consideration . 
I have chosen to use FTP as the server for the ledgerstate uploads, however to make it secure , ftps or ssh using public keys could be used. 
Modify this accordingly to suite your needs.
The comms between all my nodes and transfer is locked down to specific IP's and ports. 

### Automation steps achived

1. using cron , create and start a cardano-node on mainnet
2. check if node has fully synced
3. connect to docker containner and dump ledgerstate
4. connect to ftp server
5.  upload ledgerstate
6.  using cron, node downloads ledger state
7.  Node  then runs leaderlogs checks using cncli an dumps output to json
8.  Leader logs updates my grafana

### prerequisites for this guide

1. FTP server to upload ledgerstate . FTPS or ssh using public keys (preferred if you are worried about security). Not to concerned as this is just a ledger dump
2. Docker and Docker-compose installed
3. cron job
4. jq and working grafana dashboard (optional)

### Required files

1. ftpleader.sh ( modify accordingly if you chose to use ssh or ftps) 
2. getleaderscript.sh (script to use in cronjob)
3. getleaderdocker.sh ( script to sownload ledger state) 

## Steps

- setup remote ftp server if you dont already have
- -windows users can download a free ftp server https://www.serv-u.com/ftp-server-windows/server-setup#:~:text=Setting%20up%20an%20FTP%20site,-Navigate%20to%20Start&text=Once%20the%20IIS%20console%20is,click%20on%20Add%20FTP%20Site.&text=In%20the%20Binding%20and%20SSL,Start%20FTP%20Site%20Automatically%20option.
- - linux users know what to do . I use proftpd
- if you chose to use ssh instead ( recommended) configure using public key auth 
 https://serverpilot.io/docs/how-to-use-ssh-public-key-authentication/
 
 - Clone this repo https://github.com/casistack/cardanoledgerstate.git from the shell 
 git clone  https://github.com/casistack/cardanoledgerstate.git && cd cardanoledgerstate
 - 
 
 - edit the getleaderscript.sh paying attention to change anything  
