# osmosis
Patched and updated osmosis Docker image with automated config input.

This repo is meant to make osmosis docker image more up to date and more cloud native.
multiple changes has been made through this repository:

- LibwasmVM version has been bumped. (v1.2.3)
- osmosis core version has been bumped. (v16.1.1)
 - Entrypoint script has been added to start a full node automatically.
 - all config files has been embedded through docker image and they are configurable via environment variables.


These changes will help you to deploy osmosis in a cloud-native environment easier.

>**Note**
> By disabling snapshot restore the node start syncing from scratch.
> By default we are using polkachu snapshot files, regarding that lz4 is preinstalled in the container.

## Environment variables

The provided `.env` provides you a good set of defaults to start with. You should set some of the mandatory environments such as moniker, network name, etc.

## Network Specific variables

These are the configuration in osmosis network that is extra compared to the base cosmos environment variable set.

| Variable            |       Value        |
|---------------------|--------------------|
| CLIENT__GAS                |  1000000    |
| CLIENT__GAS_PRICES         |  0.005uosmo |
| CLIENT__GAS_ADJUSTMENT     |  1.5        |

## TODO
 - Add README badges.
 - Add automate version bump.

