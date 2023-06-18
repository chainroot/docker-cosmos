# TerraPatched
Patched and updated Terra Docker image with automated config input.

This repo is meant to make Terra docker image more up to date and more cloud native.
multiple changes has been made through this repository:

- LibwasmVM version has been bumped. (v1.1.1)
- Terra core version has been bumped. (v2.1.4)
 - Cosmovisor has been added in order to manage Terrad.
 - Entrypoint script has been added to start a full node automatically.
 - all config files has been embedded through docker image and they are configurable via environment variables.


These changes will help you to deploy Terra in a cloud-native environment easier.

## Entrypoint Script

The script uses snapshot restore method in order to bootstrap node sync.
 - Configure snapshot download URL via `SNAPSHOT__URL`.
 - Configure snapshot file name via `SNAPSHOT__FILENAME`.
 - Disable snapshot restore method by `SNAPSHOT__ENABLED`.

>**Note**
> By disabling snapshot restore the node start syncing from scratch.
> By default we are using polkachu snapshot files, regarding that lz4 is preinstalled in the container.

## Environment variables

The provided `.env.example` provides you a good set of defaults to start with. You should set some of the mandatory environments such as moniker, network name, etc.

The environment variables convention follows the template below:
 - CONFIGFILENAME__SECTION_PARAMETER

so for example `APP__API_ENABLED` indicates that this environment variable will be replaced in `app.toml` file and its related to enabling or disabling API. The table below indicates each var type, default value, and mandatory vars that should be changed.

| Variable Name | Type | Default Value | Should be changed |
|--|--|--|--|
|  |  |  |
 
.

## TODO

 - Add autobuild github workflow.
 - Add README badges.
 - Add automate version bump.

