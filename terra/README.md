# Terra
Patched and updated Terra Docker image with automated config input.

This repo is meant to make Terra docker image more up to date and more cloud native.
multiple changes has been made through this repository:

- This image has been built with skip tendermint.
- LibwasmVM version has been bumped. (v1.1.1)
- Terra core version has been bumped. (v2.3.4)
 - Entrypoint script has been added to start a full node automatically.
 - all config files has been embedded through docker image and they are configurable via environment variables.


These changes will help you to deploy Terra in a cloud-native environment easier.

>**Note**
> By disabling snapshot restore the node start syncing from scratch.
> By default we are using polkachu snapshot files, regarding that lz4 is preinstalled in the container.

## Environment variables

The provided `.env` provides you a good set of defaults to start with. You should set some of the mandatory environments such as moniker, network name, etc.

## TODO
 - Add README badges.
 - Add automate version bump.

