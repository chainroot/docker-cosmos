#!/bin/sh

CONFIG_PATH=$HOME/.osmosisd/config

envsubst < $HOME/config-sample/app.toml > $CONFIG_PATH/app.toml
envsubst < $HOME/config-sample/client.toml > $CONFIG_PATH/client.toml
envsubst < $HOME/config-sample/config.toml > $CONFIG_PATH/config.toml

if [ ! -f $HOME/.osmosisd/config/genesis.json ]; then 
  if [ $CLIENT__CHAIN_ID = "osmosis-1" ]; then
    wget -O $HOME/.osmosisd/config/genesis.json https://github.com/osmosis-labs/networks/raw/main/osmosis-1/genesis.json
    curl -o - -L https://snapshots.polkachu.com/snapshots/osmosis/osmosis_$SNAPSHOT_BLOCK_HEIGHT.tar.lz4 | lz4 -c -d - | tar -x -C $HOME/.osmosisd
    wget -O $HOME/.osmosisd/config/addrbook.json https://snapshots.polkachu.com/addrbook/osmosis/addrbook.json
  elif [ $CLIENT__CHAIN_ID = "osmo-test-4" ]; then
    SEEDS="0f9a9c694c46bd28ad9ad6126e923993fc6c56b1@137.184.181.105:26656"
    PPEERS="4ab030b7fd75ed895c48bcc899b99c17a396736b@137.184.190.127:26656,3dbffa30baab16cc8597df02945dcee0aa0a4581@143.198.139.33:26656"
    sed -i.bak -e "s/^seeds *=.*/seeds = \"$SEEDS\"/" $HOME/.terra/config/config.toml
    sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PPEERS\"/" $HOME/.terra/config/config.toml
    cd $HOME/.osmosisd/config
    wget https://github.com/osmosis-labs/networks/raw/main/osmo-test-4/genesis.tar.bz2
    tar -xjf genesis.tar.bz2 && rm genesis.tar.bz2
    URL=`curl https://dl2.quicksync.io/json/osmosis.json|jq -r '.[] |select(.file=="osmotestnet-4-pruned")|select (.mirror=="Netherlands")|.url'`
    cd $HOME/.osmosisd/
    wget -O - $URL | lz4 -d | tar -xvf -
  fi
fi

if [ ! -f $HOME/.osmosisd/cosmovisor/current/bin/osmosisd ]; then
  #Init Cosmovisor
  cosmovisor init /usr/local/bin/osmosisd
fi

cosmovisor run start