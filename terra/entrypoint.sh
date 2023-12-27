#!/bin/sh -e

CHAIN_ID=${CHAIN_ID:-"phoenix-1"}
SNAPSHOT_BLOCK_HEIGHT=${SNAPSHOT_BLOCK_HEIGHT:-"8328617"}

terrad init --chain-id $CHAIN_ID

if [ "$CHAIN_ID" = "phoenix-1" ]; then
    wget -O $HOME/.terra/config/genesis.json https://phoenix-genesis.s3.us-west-1.amazonaws.com/genesis.json
    wget -O $HOME/.terra/config/addrbook.json https://snapshots.polkachu.com/addrbook/terra/addrbook.json
    wget -O - https://snapshots.polkachu.com/snapshots/terra/terra_$SNAPSHOT_BLOCK_HEIGHT.tar.lz4 | lz4 -c -d - | tar -x -C $HOME/.terra

elif [ "$CHAIN_ID" = "pisco-1" ]; then
    wget -O $HOME/.terra/config/genesis.json https://raw.githubusercontent.com/terra-money/testnet/master/pisco-1/genesis.json
    PEERS="list_of_testnet_peers"
    sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.terra/config/config.toml
fi

terrad start