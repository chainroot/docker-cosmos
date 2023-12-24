#!/bin/sh -e

MAINNET_CHAIN_ID=$(grep 'mainnet_chain_id' ./info | cut -d '=' -f2)
TESTNET_CHAIN_ID=$(grep 'testnet_chain_id' ./info | cut -d '=' -f2)

CONFIG_PATH=$HOME/.osmosis/config

mkdir -p $CONFIG_PATH

if [ "$ENVIRONMENT" == "mainnet" ]; then
    osmosisd init --chain-id $MAINNET_CHAIN_ID
elif [ "$ENVIRONMENT" == "testnet" ]; then
    osmosisd init --chain-id $TESTNET_CHAIN_ID
fi

osmosisd start