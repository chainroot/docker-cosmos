#!/bin/sh -e

CHAIN_ID=${CHAIN_ID:-"osmosis-1"}
SNAPSHOT_BLOCK_HEIGHT=${SNAPSHOT_BLOCK_HEIGHT:-"12965183"}
MONIKER=${MONIKER:-"Chainroot"}
osmosisd init --chain-id $CHAIN_ID $MONIKER

if [ "$CHAIN_ID" = "osmosis-1" ]; then
    wget -O - https://snapshots.polkachu.com/snapshots/osmosis/osmosis_$SNAPSHOT_BLOCK_HEIGHT.tar.lz4 | lz4 -c -d - | tar -x -C $HOME/.osmosisd
    wget -O $HOME/.osmosisd/config/addrbook.json https://snapshots.polkachu.com/addrbook/osmosis/addrbook.json
    wget -O $HOME/.osmosisd/config/genesis.json https://github.com/osmosis-labs/networks/raw/main/osmosis-1/genesis.json

elif [ "$CHAIN_ID" = "osmo-test-4" ]; then
    URL=$(wget -O - https://dl2.quicksync.io/json/osmosis.json | jq -r '.[] |select(.file=="osmotestnet-4-pruned")|select (.mirror=="Netherlands")|.url')
    wget -O - $URL | lz4 -d | tar -x -C $HOME/.osmosisd

    SEEDS="seed1,seed2"
    PPEERS="peer1,peer2"
    sed -i.bak -e "s/^seeds *=.*/seeds = \"$SEEDS\"/" $HOME/.osmosisd/config/config.toml
    sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PPEERS\"/" $HOME/.osmosisd/config/config.toml

    wget -O $HOME/.osmosisd/config/genesis.json https://example.com/osmo-test-4/genesis.json
fi

osmosisd start