#!/bin/sh -e

MAINNET_CHAIN_ID=$(grep 'mainnet_chain_id' ./info | cut -d '=' -f2)
TESTNET_CHAIN_ID=$(grep 'testnet_chain_id' ./info | cut -d '=' -f2)

CONFIG_PATH=$HOME/.osmosis/config

mkdir -p $CONFIG_PATH

if [ "$ENVIRONMENT" == "mainnet" ]; then
    osmosisd init --chain-id $MAINNET_CHAIN_ID
    wget -O - https://snapshots.polkachu.com/snapshots/osmosis/osmosis_$SNAPSHOT_BLOCK_HEIGHT.tar.lz4 | lz4 -c -d - | tar -x -C $HOME/.osmosisd
    wget -O $HOME/.osmosisd/config/addrbook.json https://snapshots.polkachu.com/addrbook/osmosis/addrbook.json
    wget -O $HOME/.osmosisd/config/genesis.json https://github.com/osmosis-labs/networks/raw/main/osmosis-1/genesis.json
elif [ "$ENVIRONMENT" == "testnet" ]; then
    osmosisd init --chain-id $TESTNET_CHAIN_ID
    URL=$(wget -O - https://dl2.quicksync.io/json/osmosis.json | jq -r '.[] |select(.file=="osmotestnet-4-pruned")|select (.mirror=="Netherlands")|.url')
    wget -O - $URL | lz4 -d | tar -x -C $HOME/.osmosisd
    # TODO: Add addrbook and snapshot for osmo-test-4
fi

osmosisd start
