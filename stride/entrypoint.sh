#!/bin/sh -e

CHAIN_ID=${CHAIN_ID:-"stride-1"}
SNAPSHOT_BLOCK_HEIGHT=${SNAPSHOT_BLOCK_HEIGHT:-"6965860"}
MONIKER=${MONIKER:-"Chainroot"}
strided init --chain-id $CHAIN_ID $MONIKER

if [ "$CHAIN_ID" = "stride-1" ]; then
    wget -O $HOME/.stride/config/genesis.json https://raw.githubusercontent.com/Stride-Labs/mainnet/main/mainnet/genesis.json
    wget -O $HOME/.stride/config/addrbook.json https://snapshots.polkachu.com/addrbook/stride/addrbook.json
    wget -O snapshot.tar.lz4 https://snapshots.polkachu.com/snapshots/stride/stride_$SNAPSHOT_BLOCK_HEIGHT.tar.lz4
    lz4 -c -d snapshot.tar.lz4 | tar -x -C $HOME/.stride

elif [ "$CHAIN_ID" = "stride-testnet-1" ]; then
    wget -O $HOME/.stride/config/genesis.json https://snapshots.polkachu.com/testnet-genesis/stride/genesis.json
    wget -O $HOME/.stride/config/addrbook.json https://snapshots.polkachu.com/testnet-addrbook/stride/addrbook.json
    wget -O snapshot.tar.lz4 https://snapshots.polkachu.com/testnet-snapshots/stride/stride_$SNAPSHOT_BLOCK_HEIGHT.tar.lz4
    lz4 -c -d snapshot.tar.lz4 | tar -x -C $HOME/.stride
fi

strided start