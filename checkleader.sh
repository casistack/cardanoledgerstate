#!/bin/bash
WORKINGDIR=" "  # enter full absolute path to working dir
FTPHOST=" "       # enter ftp server hostname or IP
cd $WORKINGDIR
# remove previous dump if any
rm -f $WORKINGDIR/ledger.json
echo "getting ledger from ftp .."
#note if your files reside in a specifc dorectory on ftp modify below remotepath to match path
#curl -O ftp://anonymous@$FTPHOST/remotepath/ledger.json
curl -O ftp://anonymous@$FTPHOST/ledger.json
dumping ledger output to json
echo "getting ledger to json .."
#modify this to match full paths for
#cncli (type which cncli to get this)
#cncli.db 
#your pool id remove quotes
#your node vrfkey
#mainet shelley and byron genesis files. this will currently be used by your BP nodes
#full path to ledger.json as downloaded from ftp
#set current , prev or next . refer to cncli documentation. 
#set your prefered timezone
#set path to where the output will be dumped
/full path/cncli leaderlog -d /full path/cncli.db --pool-id "your pool id" --pool-vrf-skey /full path/vrf.skey --byron-genesis /home/cardanogoglop/cardano-my-node/mainnet-byron-genesis.json --shelley-genesis /full path/mainnet-shelley-genesis.json --ledger-state /full path/ledger.json --ledger-set current --tz Europe/London 2>&1 | tee /full path/leaderledger.json 
