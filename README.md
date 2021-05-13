# cardanoledgerstate Downloads
This was created to help those who have limited memory on their cardano-nodes and therefore downloading the ledger state (cardano-cli query ledger-state --mainnet --out-file ledger.json) sometimes exhausts resources on nodes. 
It's can also help in the automation to check leader logs in combination with Andrews cncli application https://github.com/AndrewWestberg/cncli/blob/develop/USAGE.md

#### Note: 
This was a quick put together, aka spaghetti code and therefore security and fine tuning has not been taking into consideration . 
I have chosen to use FTP as the server for the ledgerstate uploads, however to make it secure , ftps or ssh using public keys could be used. 
Modify this accordingly to suite your needs.
The comms between all my nodes and transfer is locked down to specific IP's and ports. 

This repo clone includes some IOHK files used to build docker images. Technically , the only files required are the .sh a, docker-compose.yml



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

### Required files for FTP uploads

1. ftpleader.sh ( modify accordingly if you chose to use ssh or ftps) 
2. getleaderscript.sh (script to use in cronjob)
3. getleaderdocker.sh ( script to sownload ledger state) 
4. 

## Steps for FTP upload

While this guide was configured using Linux users in mind, the is no reason why it cannot be adapted for Windows or Mac users.
For windows users, you might be able to adapt it using the windows subsystem for linux https://docs.microsoft.com/en-us/windows/wsl/install-win10
ie ubuntu from the Microsoft store. 

Better yet use ubuntu in a VM .

- setup remote ftp server if you dont already have
- -windows users can download a free ftp server https://www.serv-u.com/ftp-server-windows/server-setup#:~:text=Setting%20up%20an%20FTP%20site,-Navigate%20to%20Start&text=Once%20the%20IIS%20console%20is,click%20on%20Add%20FTP%20Site.&text=In%20the%20Binding%20and%20SSL,Start%20FTP%20Site%20Automatically%20option.
- - linux users know what to do . I use proftpd
- if you chose to use ssh instead ( recommended) configure using public key auth 
 https://serverpilot.io/docs/how-to-use-ssh-public-key-authentication/
 
 - Clone this repo https://github.com/casistack/cardanoledgerstate.git from the shell 
 git clone  https://github.com/casistack/cardanoledgerstate.git && cd cardanoledgerstate
 - 
 
 - edit the getleaderscript.sh paying attention to change anything  thats custom to your environment
 - edit the ftpleader.sh to match you setup
 - install docker and docker-compose if not already installed
 
 https://docs.docker.com/compose/install/
 https://docs.docker.com/engine/install/
 
 

## Manually test before setting up cron schedule

- The docker image is set to download at the time of the readme , cardano full node (1.26.2). you can edit the docker-compose.yml section 
 image: inputoutput/cardano-node:${CARDANO_NODE_VERSION:-1.26.2} to change the image pulled.
 
 - manually run the getleaderscript.sh script ./getleaderscript.sh  ( ensure your scripts are executable first if you get any errors chmod +x )
 - if all goes well, a new docker cardano node will be spawned, synced with the blockchain , a ledger dump taken and then upload to remote server.

## Setting up cron schedule to upload leaderlogs to ftp(linux users)

- type crontab -e
- e.g to get the dump every 12.30am upload to frp and log

modify full path accordingly to match the files containing the scripts. Important to use absolute paths of cron can have issues. 


30 0 * * * /bin/bash /full path to you working directory/getleaderscript.sh > /full path to you working directory/cron.log


## Required file for leader log checks

- checkleader.sh   (copy this file to you node and amend to match your environment)
- on your node mkdir to host the script or use exsting directory
- ensure you have cncli configured and fullign synced. ideally you will have it confiured as a systemdservice 
REF Andrew's work https://github.com/AndrewWestberg/cncli/blob/develop/USAGE.md
- for downloading the ledgerstate from ftp, i allowed anonymous access to ftp server . you can modify to match your environment.
- edit the checkleader.sh  make sure you use full path to where your files are located or cron will fail
- after editting, manually run ./checkleader.sh this and cat leaderledger.json to ensure it works as desired.

## Setting up cron schedule to check leaderlogs after downloading from ftp and dumping output to json

Outlput can then be reviewed or configured to update grafana

To get leader logs at 2.30 am and dump out configure similar to above

30 2 * * * /bin/bash /fullpath/checkleader.sh > /full path for logs/checkleaderlogging.log

## Integrating with Grafana

if you already have a prom file configured to display adapools data on grafana

https://crypto2099.io/adding-pool-stats-to-grafana-dashboard/

all i did was use JQ  to extract data from leader logs.

Note this has only been tested with one slot assigned in mind. Code may need modifications for multiple slots. 

edit the addleader.sh to match your environment

- manually run the script to see if it works
- in Grafana create the following for the dashboad. where corename is the alias if you have it configured
  name = Slot assigned
  metric = adapools_no{alias="corename"}
  
  name = Slot Number assigned
  metric = adapools_slot{alias="corename"}
  
  name = Slot in Epoch assigned
  metric = adapools_slotInEpoch{alias="corename"}
  
  Note . if you have no slot assigned output will  be " No data"
  
  
## Setup cron to update Grafana with assigned status

- e.g to setup cron to update every 7mins

*/7 * * * * /full path/addleader.sh







