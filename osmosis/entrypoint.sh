#!/bin/sh -e

OSMOSIS_PATH=$HOME/.osmosis

# Create necessary directories
mkdir -p $OSMOSIS_PATH/config 

# Replace environment variables in config files
envsubst < $HOME/config-sample/app.toml > $OSMOSIS_PATH/config/app.toml
envsubst < $HOME/config-sample/client.toml > $OSMOSIS_PATH/config/client.toml
envsubst < $HOME/config-sample/config.toml > $OSMOSIS_PATH/config/config.toml

# first time setup
if [ ! -f $OSMOSIS_PATH/config/genesis.json ]; then
  # mainnet
  if [ $CLIENT__CHAIN_ID = "osmosis-1" ]; then
    # download snapshot
    wget -O - https://snapshots.polkachu.com/snapshots/osmosis/osmosis_$SNAPSHOT_BLOCK_HEIGHT.tar.lz4 | lz4 -c -d - | tar -x -C $OSMOSIS_PATH
    # download addrbook
    wget -O $OSMOSIS_PATH/config/addrbook.json https://snapshots.polkachu.com/addrbook/osmosis/addrbook.json
    # download genesis
    wget -O $OSMOSIS_PATH/config/genesis.json https://github.com/osmosis-labs/networks/raw/main/osmosis-1/genesis.json

  # testnet TODO: automate with toolchain
  elif [ $CLIENT__CHAIN_ID = "osmo-test-4" ]; then
    URL=$(wget -O - https://dl2.quicksync.io/json/osmosis.json | jq -r '.[] |select(.file=="osmotestnet-4-pruned")|select (.mirror=="Netherlands")|.url')
    wget -O - $URL | lz4 -d | tar -x -C $OSMOSIS_PATH

    SEEDS="0f9a9c694c46bd28ad9ad6126e923993fc6c56b1@137.184.181.105:26656"
    PPEERS="4ab030b7fd75ed895c48bcc899b99c17a396736b@137.184.190.127:26656,3dbffa30baab16cc8597df02945dcee0aa0a4581@143.198.139.33:26656"
    sed -i.bak -e "s/^seeds *=.*/seeds = \"$SEEDS\"/" $OSMOSIS_PATH/config/config.toml
    sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PPEERS\"/" $OSMOSIS_PATH/config/config.toml
    cd $OSMOSIS_PATH/config
    wget https://github.com/osmosis-labs/networks/raw/main/osmo-test-4/genesis.tar.bz2
    tar -xjf genesis.tar.bz2 && rm genesis.tar.bz2
  fi
fi

osmosisd start