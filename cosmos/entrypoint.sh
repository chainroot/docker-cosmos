#!bin/sh -e

CHAIN_ID=${CHAIN_ID:-"cosmoshub-4"}
SNAPSHOT_BLOCK_HEIGHT=${SNAPSHOT_BLOCK_HEIGHT:-"18459373"}

gaiad init --chain-id $CHAIN_ID

if [ "$CHAIN_ID" = "cosmoshub-4" ]; then
    wget -O $HOME/.gaia/config/genesis.json https://raw.githubusercontent.com/cosmos/mainnet/master/genesis/genesis.cosmoshub-4.json.gz
    gzip -d $HOME/.gaia/config/genesis.cosmoshub-4.json.gz
    mv $HOME/.gaia/config/genesis.cosmoshub-4.json $HOME/.gaia/config/genesis.json
elif [ "$CHAIN_ID" = "theta-testnet-001" ]; then
fi

gaiad start