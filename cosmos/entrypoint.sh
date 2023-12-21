#!/bin/sh -e

MAINNET_CHAIN_ID=$(grep 'mainnet_chain_id' ./info | cut -d '=' -f2)
TESTNET_CHAIN_ID=$(grep 'testnet_chain_id' ./info | cut -d '=' -f2)
CONFIG_PATH=$HOME/.gaia/config

mkdir -p $CONFIG_PATH

# Copy config files
cp $HOME/config-sample/* $CONFIG_PATH/

# first time setup
if [ ! -f $CONFIG_PATH/genesis.json ]; then 
  if [ "$MAINNET_CHAIN_ID" = "cosmoshub-4" ]; then
    # Mainnet setup
    wget -O $CONFIG_PATH/addrbook.json https://dl2.quicksync.io/json/addrbook.cosmos.json
    wget -O snapshot.tar.lz4 https://snapshots.polkachu.com/snapshots/cosmos/cosmos_$SNAPSHOT_BLOCK_HEIGHT.tar.lz4
    lz4 -c -d snapshot.tar.lz4  | tar -x -C $HOME/.gaia && rm snapshot.tar.lz4
    wget https://raw.githubusercontent.com/cosmos/mainnet/master/genesis/genesis.cosmoshub-4.json.gz
    gzip -d genesis.cosmoshub-4.json.gz
    mv genesis.cosmoshub-4.json $CONFIG_PATH/genesis.json
  elif [ "$TESTNET_CHAIN_ID" = "theta-testnet-001" ]; then
    # Testnet setup
    wget https://github.com/cosmos/testnets/raw/master/public/genesis.json.gz
    gzip -d genesis.json.gz
    mv genesis.json $CONFIG_PATH/genesis.json
    # TODO: Add addrbook and snapshot for theta-testnet-001
  fi
fi

gaiad start