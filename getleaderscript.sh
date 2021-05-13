#!/bin/bash
#Note if you changed the name of the working dircetory,
#chances are your docker container will not be named  "cardanoledgerstate_cardano-node_1" 
#in that case change the container name below o match your configuration
#you can get this by manually running NETWORK=mainnet docker-compose -f docker-compose.yml up -d
#then docker ps to  get the container name 
#after run NETWORK=mainnet docker-compose -f docker-compose.yml  down  to cleanup before scheduling script
CONTAINERNAME = cardanoledgerstate_cardano-node_1
WORKINGDIR = /absolute path to working directory/ #replace path to your working directory
cd $WORKINGDIR
FILE=$WORKINGDIR/node-mainnet-ipc/node.socket
NETWORK=mainnet docker-compose -f $WORKINGDIR/docker-compose.yml up -d
 until test -S "$FILE"

 do 
  echo "$FILE does not exist."
  sleep 1

 done

    echo "$FILE exists."
    echo "getting leaderlogs.."
    /usr/bin/docker exec $CONTAINERNAME /bin/bash /mydownloads/getleaderdocker.sh
    echo "uploading to ftp''."
    $WORKINGDIR/ftpleader.sh
    echo "stopping node..."
    /usr/bin/docker stop $CONTAINERNAME
    echo "deleting node socket volumes and tidying up"
    /usr/bin/docker volume rm $CONTAINERNAME-mainnet-ipc
    /usr/bin/docker volume rm $CONTAINERNAME_.node-mainnet-ipc
    NETWORK=mainnet /usr/bin/docker-compose -f $WORKINGDIR/docker-compose.yml down 
    NETWORK=mainnet /usr/bin/docker-compose -f $WORKINGDIR/docker-compose.yml up -d
    NETWORK=mainnet /usr/bin/docker-compose -f $WORKINGDIR/docker-compose.yml down
    rm -f $WORKINGDIR/ledger.json
    echo "All done.."
