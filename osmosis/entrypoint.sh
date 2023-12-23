#!/bin/sh -e

MAINNET_CHAIN_ID=$(grep 'mainnet_chain_id' ./info | cut -d '=' -f2)
TESTNET_CHAIN_ID=$(grep 'testnet_chain_id' ./info | cut -d '=' -f2)
CONFIG_PATH=$HOME/.osmosis/config

mkdir -p $CONFIG_PATH

# Copy config files
cp $HOME/config-sample/* $CONFIG_PATH/

# first time setup
if [ ! -f $CONFIG_PATH/genesis.json ]; then 
  if [ "$MAINNET_CHAIN_ID" = "osmosis-1" ]; then
    # Mainnet setup
    wget -O $CONFIG_PATH/addrbook.json https://example.com/addrbook.osmosis.json
    wget -O snapshot.tar.lz4 https://example.com/snapshots/osmosis/osmosis_$SNAPSHOT_BLOCK_HEIGHT.tar.lz4
    lz4 -c -d snapshot.tar.lz4  | tar -x -C $HOME/.osmosis && rm snapshot.tar.lz4
    wget https://example.com/genesis/osmosis-1.json.gz
    gzip -d osmosis-1.json.gz
    mv osmosis-1.json $CONFIG_PATH/genesis.json
  elif [ "$TESTNET_CHAIN_ID" = "osmo-test-4" ]; then
    # Testnet setup
    wget https://example.com/testnets/genesis.json.gz
    gzip -d genesis.json.gz
    mv genesis.json $CONFIG_PATH/genesis.json
    # TODO: Add addrbook and snapshot for osmo-test-4
  fi
fi

osmosisd start
