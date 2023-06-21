#!/bin/sh

CONFIG_PATH=$HOME/.terra/config

if [ ! -f $HOME/.terra/config/genesis.json ]; then 
  if [ $CLIENT__CHAIN_ID = "phoenix-1" ]; then
    wget -O $CONFIG_PATH/genesis.json https://phoenix-genesis.s3.us-west-1.amazonaws.com/genesis.json
    wget -O $CONFIG_PATH/addrbook.json https://snapshots.polkachu.com/addrbook/terra/addrbook.json
  elif [ $CLIENT__CHAIN_ID = "pisco-1" ]; then
    wget -O $CONFIG_PATH/genesis.json https://raw.githubusercontent.com/terra-money/testnet/master/pisco-1/genesis.json
    PEERS=8dcd9c39b9d4a4ad4483e4558c756072997097b3@65.108.224.83:26656,948f35f9aa8817dc65fbc522ef685e9fd5beba72@198.244.179.125:30932,13138fbfc808f5c5de3832d5132f71923f174045@88.99.146.56:26656,3a4c8f4d75781f39b558c3889157acfaa144a793@50.19.18.17:26656,5502f35d9a97a7b1ca48fcc99aed316e2c43ab09@3.0.146.122:26656,bc35dcbe37d3d060a48ceefa3c984fe97c56605d@195.201.61.185:26656,b514341f9c1da1b6048f5867103a1839b1644cd8@146.59.71.241:30100,4552ad85b27151182b135e0347d2673f29566bef@185.183.33.143:26656,64cd4872abb00b67998c7cd4e4358f35219e2af1@15.235.49.45:26656,a4a8fbd7d26242263250a1d3ecb39f113832534b@52.73.183.21:26656,2bf890e8662e2bdaff997b5f30c7d50719e40b7b@107.21.250.114:26656,e2f7f6254e0c68e3ee653b9ab1456e0d71c5f649@34.239.232.196:26656,5c7b4e640a381060788e71868530501870565aa8@95.217.197.100:27656,37a80dd85e57fe5fa7f448e0653eebff8cf73178@198.244.228.16:26312,c08d5b3d253bea18b24593a894a0aa6e168079d3@34.232.34.124:26656,ce25fc7a16a9579dc37682448146c696f221e593@5.22.219.215:26656,8eb1eeb389062ed8aef579468b5cf678d9572f94@141.95.66.199:26312,255162e755668e1f5ff85b95114bf2530471bb7d@37.120.245.44:26656,cc31bc68f3f1531cf5c1a5fac0674f9aaaf2895b@52.79.113.68:26656,49309dc6665f6bb921358b141fd4e14f91fc0292@18.194.243.144:26656,651aefa892c279991b1df0cf4dd57282e95f345a@213.246.39.167:26656,8800c20c0f23b9eb86d70303785280501ad4e69d@168.119.150.243:26656,beea94b1073bf4442b8ed821ef2f537fcd924c40@15.235.53.182:26312,49c871e26f403f4f4db58de45ba729a4f7e21526@44.193.226.212:26656
    sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.terra/config/config.toml
  fi
  #Download snapshot
  wget -O snapshot.tar.lz4 https://snapshots.polkachu.com/snapshots/terra/terra_$SNAPSHOT_BLOCK_HEIGHT.tar.lz4
  #Extract data
  lz4 -c -d terra_$SNAPSHOT_BLOCK_HEIGHT.tar.lz4  | tar -x -C $HOME/.terra
fi

if [ ! -f $HOME/.terra/cosmovisor/current/bin/terrad ]; then
  #Init Cosmovisor
  cosmovisor init /usr/local/bin/terrad
fi

envsubst < $HOME/config-sample/app.toml > $CONFIG_PATH/app.toml
envsubst < $HOME/config-sample/client.toml > $CONFIG_PATH/client.toml
envsubst < $HOME/config-sample/config.toml > $CONFIG_PATH/config.toml

cosmovisor run start