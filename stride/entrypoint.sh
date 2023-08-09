#!/bin/sh

CONFIG_PATH=$HOME/.stride/config

envsubst < $HOME/config-sample/app.toml > $CONFIG_PATH/app.toml
envsubst < $HOME/config-sample/client.toml > $CONFIG_PATH/client.toml
envsubst < $HOME/config-sample/config.toml > $CONFIG_PATH/config.toml

if [ ! -f $CONFIG_PATH/genesis.json ]; then
  # mainnet
  if [ $CLIENT__CHAIN_ID = "stride-1" ]; then
    wget -O $CONFIG_PATH/genesis.json https://raw.githubusercontent.com/Stride-Labs/mainnet/main/mainnet/genesis.json
    wget -O $CONFIG_PATH/addrbook.json https://snapshots.polkachu.com/addrbook/stride/addrbook.json
    #Download snapshot
    wget -O snapshot.tar.lz4 https://snapshots.polkachu.com/snapshots/stride/stride_$SNAPSHOT_BLOCK_HEIGHT.tar.lz4
    #Extract data
    lz4 -c -d snapshot.tar.lz4  | tar -x -C $HOME/.stride

  elif [$CLIENT__CHAIN_ID = "stride-testnet-1" ];
    wget -O $CONFIG_PATH/genesis.json https://snapshots.polkachu.com/testnet-genesis/stride/genesis.json 
    wget -O $CONFIG_PATH/addrbook.json https://snapshots.polkachu.com/testnet-addrbook/stride/addrbook.json
    #Download snapshot
    wget -O snapshot.tar.lz4 https://snapshots.polkachu.com/testnet-snapshots/stride/stride_$SNAPSHOT_BLOCK_HEIGHT.tar.lz4
    #Extract data
    lz4 -c -d snapshot.tar.lz4  | tar -x -C $HOME/.stride
  fi
fi

strided start
