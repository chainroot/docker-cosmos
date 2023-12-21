#!/bin/bash

REPO=$1
DIRS=($2)

BASE_URL="https://api.github.com/repos"

for dir in "${DIRS[@]}"; do
    REPO_PART=$(cat $dir/info)
    REPO_URL="$BASE_URL/$REPO_PART/releases"
    OLD_VERSION=$(cat $dir/VERSION | grep binary | awk '{print $2}')

    LATEST_RELEASE=$(curl -s $REPO_URL | jq -r '.[0].tag_name')

    if [[ "$OLD_VERSION" != "$LATEST_RELEASE" ]]; then
        TARGET_VERSION=$LATEST_RELEASE
        GO_MOD=$(curl -s $REPO_URL/$TARGET_VERSION/go.mod)
        GO_VERSION=$(echo $GO_MOD | grep go | awk '{print $2}')
        WASM_VERSION=$(echo $GO_VERSION | grep github.com/CosmWasm/wasmvm | awk '{print $2}')

        if [[ -n $WASM_VERSION ]]; then
            echo -e "\n            go $GO_VERSION\n            wasm $WASM_VERSION\n            binary $TARGET_VERSION\n" > $dir/VERSION
        else
            echo -e "\n            go $GO_VERSION\n            binary $TARGET_VERSION\n" > $dir/VERSION
        fi
    fi
done
