#!/bin/sh -e

MAINNET_CHAIN_ID=$(grep 'mainnet_chain_id' ./info | cut -d '=' -f2)
TESTNET_CHAIN_ID=$(grep 'testnet_chain_id' ./info | cut -d '=' -f2)
CONFIG_PATH=$HOME/.terra/config

mkdir -p $CONFIG_PATH

# Copy config files
cp $HOME/config-sample/* $CONFIG_PATH/

# first time setup
if [ ! -f $CONFIG_PATH/genesis.json ]; then 
  if [ "$MAINNET_CHAIN_ID" = "columbus-5" ]; then
    # Mainnet setup
    wget -O $CONFIG_PATH/addrbook.json https://example.com/addrbook.terra.json
    wget -O snapshot.tar.lz4 https://example.com/snapshots/terra/terra_$SNAPSHOT_BLOCK_HEIGHT.tar.lz4
    lz4 -c -d snapshot.tar.lz4  | tar -x -C $HOME/.terra && rm snapshot.tar.lz4
    wget https://example.com/genesis/columbus-5.json.gz
    gzip -d columbus-5.json.gz
    mv columbus-5.json $CONFIG_PATH/genesis.json
  elif [ "$TESTNET_CHAIN_ID" = "bombay-12" ]; then
    # Testnet setup
    wget https://example.com/testnets/genesis.json.gz
    gzip -d genesis.json.gz
    mv genesis.json $CONFIG_PATH/genesis.json
    # TODO: Add addrbook and snapshot for bombay-12
  fi
fi

terrad start