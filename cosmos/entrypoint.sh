#!/bin/sh -e

CONFIG_PATH=$HOME/.gaia/config

mkdir -p $CONFIG_PATH

envsubst < $HOME/config-sample/app.toml > $CONFIG_PATH/app.toml
envsubst < $HOME/config-sample/client.toml > $CONFIG_PATH/client.toml
envsubst < $HOME/config-sample/config.toml > $CONFIG_PATH/config.toml

# first time setup
if [ ! -f $CONFIG_PATH/genesis.json ]; then 
  # mainnet
  if [ $CLIENT__CHAIN_ID = "cosmoshub-4" ]; then
    #Download addrbook
    wget -O $CONFIG_PATH/addrbook.json https://dl2.quicksync.io/json/addrbook.cosmos.json
    #Download snapshot
    wget -O snapshot.tar.lz4 https://snapshots.polkachu.com/snapshots/cosmos/cosmos_$SNAPSHOT_BLOCK_HEIGHT.tar.lz4
    #Extract data and remove snapshot
    lz4 -c -d snapshot.tar.lz4  | tar -x -C $HOME/.gaia && rm snapshot.tar.lz4
    #Download genesis
    wget https://raw.githubusercontent.com/cosmos/mainnet/master/genesis/genesis.cosmoshub-4.json.gz
    gzip -d genesis.cosmoshub-4.json.gz
    mv genesis.cosmoshub-4.json $CONFIG_PATH/genesis.json

  # testnet
  elif [ $CLIENT__CHAIN_ID = "theta-testnet-001" ]; then
    wget https://github.com/cosmos/testnets/raw/master/public/genesis.json.gz
    gzip -d genesis.json.gz
    mv genesis.json $CONFIG_PATH/genesis.json
    # TODO download addrbook and snapshot for theta-testnet-001
  fi
fi

gaiad start
