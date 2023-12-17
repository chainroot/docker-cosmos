#!/bin/bash

REPO = input 1
DIRS = input 2

semver_compare() {
  local version_a version_b pr_a pr_b
  # strip word "v" and extract first subset version (x.y.z from x.y.z-foo.n)
  version_a=$(echo "${1//v/}" | awk -F'-' '{print $1}')
  version_b=$(echo "${2//v/}" | awk -F'-' '{print $1}')

  if [ "$version_a" \= "$version_b" ]
  then
    # check for pre-release
    # extract pre-release (-foo.n from x.y.z-foo.n)
    pr_a=$(echo "$1" | awk -F'-' '{print $2}')
    pr_b=$(echo "$2" | awk -F'-' '{print $2}')

    ####
    # Return 0 when A is equal to B
    [ "$pr_a" \= "$pr_b" ] && echo 0 && return 0

    ####
    # Return 1

    # Case when A is not pre-release
    if [ -z "$pr_a" ]
    the
      echo 1 && return 0
    fi

    ####
    # Case when pre-release A exists and is greater than B's pre-release

    # extract numbers -rc.x --> x
    number_a=$(echo ${pr_a//[!0-9]/})
    number_b=$(echo ${pr_b//[!0-9]/})
    [ -z "${number_a}" ] && number_a=0
    [ -z "${number_b}" ] && number_b=0

    [ "$pr_a" \> "$pr_b" ] && [ -n "$pr_b" ] && [ "$number_a" -gt "$number_b" ] && echo 1 && return 0

    ####
    # Retrun -1 when A is lower than B
    echo -1 && return 0
  fi
  arr_version_a=(${version_a//./ })
  arr_version_b=(${version_b//./ })
  cursor=0
  # Iterate arrays from left to right and find the first difference
  while [ "$([ "${arr_version_a[$cursor]}" -eq "${arr_version_b[$cursor]}" ] && [ $cursor -lt ${#arr_version_a[@]} ] && echo true)" == true ]
  do
    cursor=$((cursor+1))
  done
  [ "${arr_version_a[$cursor]}" -gt "${arr_version_b[$cursor]}" ] && echo 1 || echo -1
}

[ -n "$1" ] && echo $(semver_compare $1 $2)

for dir in "${dirs[@]}"; do
    REPO_URL = $(cat $dir/info)
    OLD_VERSION = $(cat dir/VERSION | grep binary | awk '{print $2}')
    LATEST_RELEASE = $(curl $REPO_URL/releases/latest | jq '.tag_name')
    LATEST_PRERELEASE = $(curl $REPO_URL/releases | jq '[.[] | select(.prerelease == true)][0] | .tag_name')
    DIFF_RELEASE = semver_compare(OLD_VERSION, LATEST_RELEASE)
    DIFF_PRERELEASE = semver_compare(OLD_VERSION, LATEST_PRERELEASE)    
    if [[ $DIFF_RELEASE == -1 ]]; then
        TARGET_VERSION = $LATEST_RELEASE
    elif [[ $DIFF_PRELEASE == -1]]; then
        TARGET_VERSION = $LATEST_PRERELEASE
    fi
    fi
    GO_MOD = $( curl $REPO_URL/$TARGET_VERSION/go.mod )
    GO_VERSION = $( echo $GO_MOD | grep go | awk '{print $2}')
    WASM_VERSION = $( echo $GO_VERSION | grep github.com/CosmWasm/wasmvm | awk '{print $2}')
    if [[ -n $WASM_VERSION ]]; then
        echo " 
            go $GO_VERSION
            wasm $WASM_VERSION
            binary $TARGET_VERSION
            " > $dir/VERSION
    else
        echo "
            go $GO_VERSION
            binary $TARGET_VERSION
            " > $dir/VERSION
    fi
