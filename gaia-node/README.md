# TerraPatched
..
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

## TODO
 - Add README badges.
 - Add automate version bump.


## Environment variables

The provided `.env.example` provides you a good set of defaults to start with. You should set some of the mandatory environments such as moniker, network name, etc.

The environment variables convention follows the template below:
 - CONFIGFILENAME__SECTION_PARAMETER

so for example `APP__API_ENABLED` indicates that this environment variable will be replaced in `app.toml` file and its related to enabling or disabling API. The table below indicates each var type, default value, and mandatory vars that should be changed.

Certainly! Based on the provided variables and their descriptions, here's a section with tips on changing these variables:

### Tips for Configuring the Node

1. **Snapshot Configuration**:
   - `SNAPSHOT_BLOCK_HEIGHT`: If you want to start the node from a specific block height, you can modify this variable to set the desired snapshot block height.

2. **App Configuration**:
   - The app configuration variables control various aspects of the Terra node. You can adjust these variables according to your requirements:
     - Pruning: The variables starting with `APP__PRUNE_` determine the pruning settings. You can customize the pruning method, the number of recent blocks to keep, and the interval between pruning.
     - Telemetry: Adjust the telemetry-related variables (`APP__TELEMETRY_`) to enable or disable telemetry and configure its settings.
     - API: Customize the API settings by modifying variables starting with `APP__API_`. You can enable/disable the API, set the listening address, configure maximum connections, timeouts, and other API-related parameters.
     - Rosetta: If you plan to use Rosetta for blockchain interoperability, configure the variables starting with `APP__ROSETTA_`. Enable/disable Rosetta, set the listening address, blockchain name, network name, and other Rosetta-related settings.
     - gRPC: Adjust the gRPC-related variables (`APP__GRPC_`) to enable/disable gRPC, set the listening address, enable/disable gRPC Web, and configure CORS settings.

3. **Client Configuration**:
   - The client configuration variables control the behavior of the Terra client. You can customize these variables based on your needs:
     - Chain ID: Set `CLIENT__CHAIN_ID` to the desired chain ID.
     - Keyring Backend: Choose the keyring backend (`CLIENT__KEYRING_BACKEND`) that suits your requirements.
     - CLI Output: Modify `CLIENT__CLI_OUTPUT` to specify the output format of the CLI commands.
     - Tendermint RPC Address: Set `CLIENT__TENDERMINT_RPC_ADDR` to the address of the Tendermint RPC server.

4. **Config Configuration**:
   - The config configuration variables control the settings of the Terra node. You can modify these variables as follows:
     - Moniker Name: Change `CONFIG__MONIKER_NAME` to set a unique moniker for your node.
     - Backend DB: Choose the backend database (`CONFIG__BACKEND_DB`) that you want to use, such as GoLevelDB or another supported database.
     - Log Level and Format: Adjust `CONFIG__LOG_LEVEL` and `CONFIG__LOG_FORMAT` to customize the log level and format.
     - Genesis Path: Set `CONFIG__GENESIS_PATH` to the path of your custom genesis file.
     - P2P Configuration: Configure the P2P networking settings by modifying the variables starting with `CONFIG__P2P_`. You can set the listening address, enable/disable UPnP, configure maximum inbound/outbound peers, and other P2P-related parameters.
     - RPC Configuration: Customize the RPC settings by modifying the variables starting with `CONFIG__RPC_`. You can set the listening address, configure CORS settings, adjust maximum body/header size, enable TLS, and other RPC-related parameters.
     - Mempool Configuration: Modify the variables starting with `CONFIG__MEMPOOL_` to configure the behavior of the mempool. You can adjust the transaction count/size limits, cache size, and other mempool-related settings.
     - Consensus Configuration: Adjust the variables starting with `CONFIG__CONSENSUS_` to fine-tune the consensus parameters, such as propose/prevote/precommit timeouts, block creation interval, and other consensus-related settings.
     -

 Prometheus: Enable/disable Prometheus metrics by modifying `CONFIG__PROMETHEUS_ENABLED` and configure the listening address and maximum connections using the corresponding variables.

These tips provide an overview of the variables and their configurations. It's important to refer to the Terra documentation or consult the project's maintainers for detailed guidance on customizing these variables based on the specific requirements of the Terra blockchain and the node daemon you are using.

<details>
    <summary>Click to expand/collapse</summary>

## Snapshot
| Variable                   | Description                           | Default Value  |
|----------------------------|---------------------------------------|----------------|
| SNAPSHOT_BLOCK_HEIGHT      | Snapshot block height                  | 13419357       |

## App
| Variable                   | Description                           | Default Value  |
|----------------------------|---------------------------------------|----------------|
| APP__MIN_GAS_PRICE         | Minimum gas price                      | "0.0025uatom"  |
| APP__PRUNE_METHOD          | Prune method                           | "custom"       |
| APP__PRUNE_KEEP_RECENT     | Number of recent blocks to keep        | "100"          |
| APP__PRUNE_KEEP_EVERY      | Number of blocks to keep in between    | "0"            |
| APP__PRUNE_INTERVAL        | Prune interval in blocks               | "10"           |
| APP__HALT_HEIGHT           | Halt height                            | 0              |
| APP__HALT_TIME             | Halt time (in seconds)                 | 0              |
| APP__MIN_RETAIN_BLOCKS     | Minimum retained blocks                | 0              |
| APP__INTER_BLOCK_CACHE     | Inter-block cache                      | true           |
| APP__INDEX_EVENTS          | Index events                           | []             |
| APP__IAVL_CACHE_SIZE       | IAVL cache size                        | 781250         |
| APP__TELEMETRY_KEY_PREFIX  | Telemetry key prefix                   | ""             |
| APP__TELEMETRY_ENABLED     | Telemetry enabled                      | false          |
| APP__TELEMETRY_HOSTNAME_ENABLED     | Telemetry hostname enabled     | false          |
| APP__TELEMETRY_HOSTNAME__LABEL_ENABLED     | Telemetry hostname label enabled     | false          |
| APP__TELEMETRY_SERVICE_LABEL_ENABLED     | Telemetry service label enabled     | false          |
| APP__TELEMETRY_PROMETHEUS_RET_TIME     | Telemetry Prometheus retention time     | 0          |
| APP__TELEMETRY_GLOBAL_LABEL     | Telemetry global label     | []          |
| APP__API_ENABLED           | API enabled                            | true           |
| APP__API_SWAGGER_ENABLED   | API Swagger enabled                    | true           |
| APP__API_LADDR             | API listening address                   | "tcp://0.0.0.0:1317"  |
| APP__API_MAX_CONN          | API maximum connections                | 1000           |
| APP__API_RPC_R_TIMEOUT     | API RPC read timeout                    | 10             |
| APP__API_RPC_W_TIMEOUT     | API RPC write timeout                   | 0              |
| APP__API_RPC_MAX_BODYSIZE  | API RPC maximum body size               | 1000000        |
| APP__API_UNSAFE_CORES_ENABLED | Unsafe cores enabled                 | true           |
| APP__ROSETTA_ENBALED       | Rosetta enabled                        | false          |
| APP__ROSETTA_LADDR         | Rosetta listening address               | ":8080"        |
| APP__ROSETTA_BLOCKCHAIN_NAME | Rosetta blockchain name                | "app"          |
| APP__ROSETTA_NETWORK_NAME  | Rosetta network name                    | "network"      |
| APP__ROSETTA_RETRY_COUNT   | Rosetta retry count                     | 3              |
| APP__ROSETTA_OFFLINE_ENABLED   | Rosetta offline enabled             | false          |
| APP__GRPC_ENABLED          | gRPC enabled                           | true           |
| APP__GRPC_LADDR            | gRPC listening address                  | "0.0.0.0:9090" |
| APP__GRPC_WEB_ENABLED      | gRPC web enabled                       | true           |
| APP__GRPC_WEB_LADDR        | gRPC web listening address              | "0.0.0.0:9091" |
| APP__GRPC_WEB_UNSAFE_CORS_ENABLED | gRPC web unsafe CORS enabled     | true           |
| APP__STATESYNC_INTERVAL    | Statesync interval                      | 0              |
| APP__STATESYNC_KEEP_RECENT | Statesync keep recent                   | 0              |
| APP__WASM_QUERY_GAS_LIMIT  | Wasm query gas limit                    | 300000         |
| APP__WASM_WASMVM_CACHE     | WasmVM cache size                       | 0              |

## Client
| Variable                   | Description                           | Default Value  |
|----------------------------|---------------------------------------|----------------|
| CLIENT__CHAIN_ID           | Chain ID                              | "cosmoshub-4" |
| CLIENT__KEYRING_BACKEND    | Keyring backend                        | "os"           |
| CLIENT__CLI_OUTPUT         | CLI output format                      | "json"         |
| CLIENT__TENDERMINT_RPC_ADDR | Tendermint RPC address                 | "tcp://localhost:26657" |
| CLIENT__BROADCAST_MODE     | Broadcast mode                         | "sync"         |

## Config
| Variable                   | Description                           | Default Value  |
|----------------------------|---------------------------------------|----------------|
| CONFIG__ABCI_LADDR         | ABCI listening address                 | "tcp://127.0.0.1:26658" |
| CONFIG__MONIKER_NAME       | Moniker name                           | "PRISM Protocol" |
| CONFIG__FAST_SYNC_ENABLED  | Fast sync enabled                      | true           |
| CONFIG__BACKEND_DB         | Backend database                       | "goleveldb"    |
| CONFIG__DB_DIR             | Database directory                     | "data"         |
| CONFIG__LOG_LEVEL          | Log level                              | "info"         |
| CONFIG__LOG_FORMAT         | Log format                             | "plain"        |
| CONFIG__GENESIS_PATH       | Genesis file path                      | "config/genesis.json" |
| CONFIG__PRIV_KEY_PATH      | Private key file path                   | "config/priv_validator_key.json" |
| CONFIG__STATE_PATH         | State file path                        | "data/priv_validator_state.json" |
| CONFIG__LADDR              | Listening address                      | ""             |
| CONFIG__NODE_KEY_PATH      | Node key file path                      | "config/node_key.json" |
| CONFIG__ABCI_CONNECT_METHOD | ABCI connection method                 | "socket"       |
| CONFIG__FILTER_PEERS       | Filter peers                           | false          |
| CONFIG__RPC_LADDR          | RPC listening address                   | "tcp://0.0.0.0:26657" |
| CONFIG__RPC_CORS_ALLOWED_ORIGINS | Allowed RPC CORS origins           | []             |
| CONFIG__RPC_CORS_ALLOWED_METHODS | Allowed RPC CORS methods           | [ "HEAD", "GET", "POST" ] |
| CONFIG__RPC_CORS_ALLOWED_HEADERS | Allowed RPC CORS headers           | ["Origin", "Accept", "Content-Type", "X-Requested-With", "X-Server-Time" ] |
| CONFIG__GRPC_LADDR         | gRPC listening address                  | ""             |
| CONFIG__GRPC_MAX_CONN      | Maximum gRPC connections               | 900            |
| CONFIG__RPC_UNSAFE_COMMAND_ENABLED | Unsafe RPC commands enabled     | false          |
| CONFIG__RPC_CONCURRENT_TOTAL_CONN | RPC concurrent total connections | 900            |
| CONFIG__RPC_MAX_UNIQUE_CLIENT_ID | Maximum unique client IDs         | 100            |
| CONFIG__RPC_MAX_SUBSCRIBE_PER_CLIENT | Maximum subscriptions per client | 5              |
| CONFIG__RPC_EXP_SUBSCRIBE_BUFFER_SIZE | Expanded subscription buffer size | 200        |
| CONFIG__RPC_EXP_WS_BUFFER_SIZE | Expanded WebSocket buffer size       | 200            |
| CONFIG__RPC_EXP_CLOSE_SLW_CLIENT | Expanded slow client closing      | false          |
| CONFIG__RPC_BROADCAST_TIMEOUT | RPC broadcast timeout                | "30s"          |
| CONFIG__RPC_MAX_BODY_SIZE  | Maximum RPC body size                  | 1000000        |
| CONFIG__RPC_MAX_HEADER_SIZE | Maximum RPC header size                | 1048576        |
| CONFIG__RPC_TLS_CERT_FILE  | RPC TLS certificate file               | ""             |
| CONFIG__RPC_TLS_KEY_FILE   | RPC TLS key file                        | ""             |
| CONFIG__RPC_PPROF_LADDR    | RPC pprof listening address             | "localhost:6060" |
| CONFIG__P2P_LADDR          | P2P listening address                   | "tcp://0.0.0.0:26656" |
| CONFIG__P2P_EXT_ADDR       | P2P external address                    | ""             |
| CONFIG__P2P_SEEDS          | P2P seeds (addresses)                   | ""             |
| CONFIG__P2P_PSEEDS         | P2P persistent seeds (addresses)        | ""             |
| CONFIG__P2P_UPNP_ENABLED   | P2P UPnP enabled                        | false          |
| CONFIG__P2P_ADDR_BOOK_PATH | P2P address book file path              | "config/addrbook.json" |
| CONFIG__P2P_ADDR_BOOK_STRICT_ENABLED | P2P strict address book enabled | true   |
| CONFIG__P2P_MAX_INBOUND_PEERS | Maximum inbound peers                | 40             |
| CONFIG__P2P_MAX_OUTBOUND_PEERS | Maximum outbound peers              | 10             |
| CONFIG__P2P_UNCOND_PEERS   | Unconditional peers (addresses)         | ""             |
| CONFIG__P2P_MAX_DIAL_PPEERS | Maximum dial peers per second          | "0s"           |
| CONFIG__P2P_FLUSH_TIMEOUT  | P2P flush timeout                      | "100ms"        |
| CONFIG__P2P_MAX_PAYLOAD_SIZE | Maximum P2P payload size              | 1024           |
| CONFIG__P2P_SENDRATE       | P2P send rate (bytes/sec)               | 5120000        |
| CONFIG__P2P_RCVRATE        | P2P receive rate (bytes/sec)            | 5120000        |
| CONFIG__P2P_PEX_ENABLED    | P2P peer exchange enabled               | true           |
| CONFIG__P2P_SEED_MODE_ENABLED | P2P seed mode enabled                | false          |
| CONFIG__P2P_PRIV_PEERS     | P2P private peers (addresses)           | ""             |
| CONFIG__P2P_ALLOW_DUP_IP   | P2P allow duplicate IPs                 | false          |
| CONFIG__P2P_HANDSHAKE_TIMEOUT | P2P handshake timeout                | "20s"          |
| CONFIG__P2P_DIAL_TIMEOUT   | P2P dial timeout                        | "3s"           |
| CONFIG__MEMPOOL_VERSION    | Mempool version                        | "v0"           |
| CONFIG__MEMPOOL_RECHECK    | Mempool recheck enabled                 | true           |
| CONFIG__MEMPOOL_BROADCAST_ENABLED | Mempool broadcast enabled         | true           |
| CONFIG__MEMPOOL_WAL_DIR    | Mempool WAL directory                   | ""             |
| CONFIG__MEMPOOL_TX_MAX_COUNT | Mempool maximum transaction count     | 5000           |
| CONFIG__MEMPOOL_TX_MAX_SIZE | Mempool maximum transaction size        | 1073741824     |
| CONFIG__MEMPOOL_CACHE_SIZE | Mempool cache size                      | 10000          |
| CONFIG__MEMPOOL_TX_INVALID_CACHE_ENABLED | Mempool invalid transaction cache enabled | false |
| CONFIG__MEMPOOL_TX_SINGLE_SIZE | Mempool transaction single size      | 1048576        |
| CONFIG__MEMPOOL_TX_BATCH_SIZE | Mempool transaction batch size        | 0              |
| CONFIG__MEMPOOL_TX_TTL_TIME | Mempool transaction TTL time            | "0s"           |
| CONFIG__MEMPOOL_TX_TTL_BLOCKS | Mempool transaction TTL blocks        | 0              |
| CONFIG__STATESYNC_ENABLED  | Statesync enabled                       | false          |
| CONFIG__STATESYNC_RPC_SERVERS | Statesync RPC servers                 | ""             |
| CONFIG__STATESYNC_TRUST_HEIGHT | Statesync trusted height              | 0              |
| CONFIG__STATESYNC_TRUST_HASH | Statesync trusted hash                  | ""             |
| CONFIG__STATESYNC_TRUST_PERIOD | Statesync trusted period              | "168h0m0s"     |
| CONFIG__STATESYNC_DISCOVERY_TIME | Statesync discovery time            | "15s"          |
| CONFIG__STATESYNC_TEMP_DIR | Statesync temporary directory           | ""             |
| CONFIG__STATESYNC_CHUNK_TIMEOUT | Statesync chunk timeout              | "10s"          |
| CONFIG__STATESYNC_CHUNK_FETCH_COUNT | Statesync chunk fetch count       | "4"            |
| CONFIG__FSYNC_VERSION      | Fsync version                          | "v0"           |
| CONFIG__CONSENSUS_WAL_PATH | Consensus WAL path                      | "data/cs.wal/wal" |
| CONFIG__CONSENSUS_PROPOSE_TIMEOUT | Consensus propose timeout          | "3s"           |
| CONFIG__CONSENSUS_PROPOSE_DELTA | Consensus propose delta              | "500ms"        |
| CONFIG__CONSENSUS_PREVOTE_TIMEOUT | Consensus prevote timeout          | "1s"           |
| CONFIG__CONSENSUS_PREVOTE_DELTA | Consensus prevote delta              | "500ms"        |
| CONFIG__CONSENSUS_PRECOMMIT_TIMEOUT | Consensus precommit timeout      | "1s"           |
| CONFIG__CONSENSUS_PRECOMMIT_DELTA | Consensus precommit delta          | "500ms"        |
| CONFIG__CONSENSUS_COMMIT_TIMEOUT | Consensus commit timeout            | "5s"           |
| CONFIG__CONSENSUS_DSIGN_CHECK_HEIGHT | Consensus dsign check height     | 0              |
| CONFIG__CONSENSUS_COMMIT_SKIP_TIMEOUT | Consensus commit skip timeout    | false          |
| CONFIG__CONSENSUS_BLOCK_CREATE_EMPTY_ENABLED | Consensus block create empty enabled | true |
| CONFIG__CONSENSUS_BLOCK_CREATE_EMPTY_INTERVAL | Consensus block create empty interval | "0s" |
| CONFIG__CONSENSUS_PEER_GOSSIP_SLEEP | Consensus peer gossip sleep        | "100ms"        |
| CONFIG__CONSENSUS_PEER_QUERY_SLEEP | Consensus peer query sleep          | "2s"           |
| CONFIG__CONSENSUS_ABCI_DISCARD_RESPONSE_ENABLED | Consensus ABCI discard response enabled | false |
| CONFIG__INDEXER_TYPE        | Indexer type                          | "null"         |
| CONFIG__INDEXER_PSQL_CONN   | Indexer PostgreSQL connection string  | ""             |
| CONFIG__PROMETHEUS_ENABLED | Prometheus enabled                     | false          |
| CONFIG_PROMETHEUS_LADDR    | Prometheus listening address           | ":26660"       |
| CONFIG__PROMETHEUS_MAX_CONN | Prometheus maximum connections        | 3              |
| CONFIG__PROMETHEUS_NAMESPACE | Prometheus namespace                  | "tendermint"   |

</details>