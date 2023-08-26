# Environment Variables Guide

This document provides a comprehensive list of environment variables for the customized cosmos based network docker images. It includes detailed descriptions and default values for each variable, aiding in the setup and customization of the network. The variables are organized into tables, based on different files for easy reference.

The naming structure of the environment variables is designed to clearly indicate the scope of each variable, using double underscores as separators. The first part of the name (before the first underscore) corresponds to the configuration file that the variable belongs to (`app.toml`, `client.toml`, `config.toml`). The rest of the name indicates the specific setting within that configuration. For example, in the variable `APP__MIN_GAS_PRICE`, `APP` refers to the application configuration, while MIN_GAS_PRICE refers to the specific setting for the minimum gas price within the application.

In certain cases where the variable represents a deeper level of configuration, the name comprises an additional component. The second part in these cases indicates the specific subcategory within the larger configuration. For instance, in `CONFIG__CONSENSUS_DSIGN_CHECK_HEIGHT`, `CONSENSUS` indicates that the setting belongs to the consensus configuration within the larger `CONFIG` configuration, and `DSIGN_CHECK_HEIGHT` refers to the specific setting of checking height for double signing in the consensus protocol.

This structured naming convention helps in organizing and identifying the settings with ease, providing a hierarchical perspective to the configuration options.


## Init Parameters

| Variable                  | Description                                         | Value        |
|---------------------------|-----------------------------------------------------|--------------|
| SNAPSHOT_BLOCK_HEIGHT     | Snapshot block height for the network              |      |

## App.toml

| Environment Variable | Value | Description |
|----------------------|-------|-------------|
| APP__MIN_GAS_PRICE | "0.0025uDENOM" | Minimum gas price |
| APP__PRUNE_METHOD | "custom" | Prune method |
| APP__PRUNE_KEEP_RECENT | "100" | Number of recent states to keep |
| APP__PRUNE_INTERVAL | "10" | Interval for pruning |
| APP__HALT_HEIGHT | 0 | Blockchain halt height |
| APP__HALT_TIME | 0 | Blockchain halt time |
| APP__MIN_RETAIN_BLOCKS | 0 | Minimum number of blocks to retain |
| APP__INTER_BLOCK_CACHE | true | Enable inter-block cache |
| APP__INDEX_EVENTS | [] | List of events to index |
| APP__IAVL_CACHE_SIZE | 781250 | Size of the IAVL cache |
| APP__TELEMETRY_KEY_PREFIX | "" | Prefix for telemetry keys |
| APP__TELEMETRY_ENABLED | false | Enable telemetry |
| APP__TELEMETRY_HOSTNAME_ENABLED | false | Enable telemetry hostname |
| APP__TELEMETRY_HOSTNAME__LABEL_ENABLED | false | Enable telemetry hostname label |
| APP__TELEMETRY_SERVICE_LABEL_ENABLED | false | Enable telemetry service label |
| APP__TELEMETRY_PROMETHEUS_RET_TIME | 0 | Prometheus return time for telemetry |
| APP__TELEMETRY_GLOBAL_LABEL | [] | Global labels for telemetry |
| APP__API_ENABLED | true | Enable API |
| APP__API_SWAGGER_ENABLED | true | Enable Swagger for API |
| APP__API_LADDR | "tcp://0.0.0.0:1317" | Local address for API |
| APP__API_MAX_CONN | 1000 | Maximum API connections |
| APP__API_RPC_R_TIMEOUT | 10 | Read timeout for API RPC |
| APP__API_RPC_W_TIMEOUT | 0 | Write timeout for API RPC |
| APP__API_RPC_MAX_BODYSIZE | 1000000 | Maximum body size for API RPC |
| APP__API_UNSAFE_CORES_ENABLED | true | Enable unsafe cores for API |
| APP__ROSETTA_ENABLED | false | Enable Rosetta |
| APP__ROSETTA_LADDR | ":8080" | Local address for Rosetta |
| APP__ROSETTA_BLOCKCHAIN_NAME | "app" | Blockchain name for Rosetta |
| APP__ROSETTA_NETWORK_NAME | "network" | Network name for Rosetta |
| APP__ROSETTA_RETRY_COUNT | 3 | Retry count for Rosetta |
| APP__ROSETTA_OFFLINE_ENABLED | false | Enable offline mode for Rosetta |
| APP__GRPC_ENABLED | true | Enable gRPC |
| APP__GRPC_LADDR | "0.0.0.0:9090" | Local address for gRPC |
| APP__GRPC_MAX_RCV_SIZE | "10485760" | Maximum receive size for gRPC |
| APP__GRPC_MAX_SEND_SIZE | "2147483647" | Maximum send size for gRPC |
| APP__GRPC_CONCURRENCY_ENABLED | false | Enable gRPC concurrency |
| APP__GRPC_WEB_ENABLED | true | Enable gRPC Web |
| APP__GRPC_WEB_LADDR | "0.0.0.0:9091" | Local address for gRPC Web |
| APP__GRPC_WEB_UNSAFE_CORS_ENABLED | true | Enable unsafe CORS for gRPC Web |
| APP__STATESYNC_INTERVAL | 0 | State sync interval |
| APP__STATESYNC_KEEP_RECENT | 0 | Number of recent states to keep for state sync |
| APP__MEMPOOL_MAX_GAS | "25000000" | Maximum gas for mempool |
| APP__MEMPOOL_ARBITRAGE_MIN_GAS | ".005" | Minimum arbitrage gas for mempool |
| APP__MEMPOOL_MIN_GAS_HIGH_GAS | ".0025" | Minimum high gas for mempool |

## Config.toml

Here are the environment variables for the config configuration.

| Environment Variable | Value | Description |
|----------------------|-------|-------------|
| CONFIG__ABCI_LADDR | "tcp://127.0.0.1:26658" | ABCI local address |
| CONFIG__MONIKER_NAME | "Chainroot OSS" | Moniker name |
| CONFIG__FAST_SYNC_ENABLED | true | Fast sync enabled |
| CONFIG__BACKEND_DB | "goleveldb" | Backend database |
| CONFIG__DB_DIR | "data" | Database directory |
| CONFIG__LOG_LEVEL | "info" | Log level |
| CONFIG__LOG_FORMAT | "plain" | Log format |
| CONFIG__GENESIS_PATH | "config/genesis.json" | Genesis file path |
| CONFIG__PRIV_KEY_PATH | "config/priv_validator_key.json" | Private key file path |
| CONFIG__PRIV_STATE_PATH | "data/priv_validator_state.json" | State file path |
| CONFIG__PRIV_LADDR | "" | Local address |
| CONFIG__NODE_KEY_PATH | "config/node_key.json" | Node key file path |
| CONFIG__ABCI_CONNECT_METHOD | "socket" | ABCI connect method |
| CONFIG__FILTER_PEERS | false | Filter peers |
| CONFIG__RPC_LADDR | "tcp://0.0.0.0:26657" | RPC local address |
| CONFIG__RPC_CORS_ALLOWED_ORIGINS | [] | Allowed origins for RPC CORS |
| CONFIG__RPC_CORS_ALLOWED_METHODS | [ "HEAD", "GET", "POST", ] | Allowed methods for RPC CORS |
| CONFIG__RPC_CORS_ALLOWED_HEADERS | ["Origin", "Accept", "Content-Type", "X-Requested-With", "X-Server-Time", ] | Allowed headers for RPC CORS |
| CONFIG__GRPC_LADDR | "" | gRPC local address |
| CONFIG__GRPC_MAX_CONN | 900 | Maximum gRPC connections |
| CONFIG__RPC_UNSAFE_COMMAND_ENABLED | false | Unsafe command enabled for RPC |
| CONFIG__RPC_CONCURRENT_TOTAL_CONN | 900 | Total concurrent connections for RPC |
| CONFIG__RPC_MAX_UNIQUE_CLIENT_ID | 100 | Maximum unique client id for RPC |
| CONFIG__RPC_MAX_SUBSCRIBE_PER_CLIENT | 5 | Maximum subscriptions per client for RPC |
| CONFIG__RPC_EXP_SUBSCRIBE_BUFFER_SIZE | 200 | Expected subscribe buffer size for RPC |
| CONFIG__RPC_EXP_WS_BUFFER_SIZE | 200 | Expected WebSocket buffer size for RPC |
| CONFIG__RPC_EXP_CLOSE_SLOW_CLIENT | false | Expected close slow client for RPC |
| CONFIG__RPC_BROADCAST_TIMEOUT | "30s" | Broadcast timeout for RPC |
| CONFIG__RPC_MAX_BODY_SIZE | 1000000 | Maximum body size for RPC |
| CONFIG__RPC_MAX_HEADER_SIZE | 1048576 | Maximum header size for RPC |
| CONFIG__RPC_TLS_CERT_FILE | "" | TLS certificate file for RPC |
| CONFIG__RPC_TLS_KEY_FILE | "" | TLS key file for RPC |
| CONFIG__RPC_PPROF_LADDR | "localhost:6060" | pprof local address for RPC |
| CONFIG__P2P_LADDR | "tcp://0.0.0.0:26656" | P2P local address |
| CONFIG__P2P_EXT_ADDR | "" | P2P external address |
| CONFIG__P2P_SEEDS | "" | P2P seeds |
| CONFIG__P2P_PSEEDS | "" | P2P persistent seeds |
| CONFIG__P2P_UPNP_ENABLED | false | P2P UPnP enabled |
| CONFIG__P2P_ADDR_BOOK_PATH | "config/addrbook.json" | Address book path for P2P |
| CONFIG__P2P_ADDR_BOOK_STRICT_ENABLED | true | Address book strict mode enabled for P2P |
| CONFIG__P2P_MAX_INBOUND_PEERS | 40 | Maximum inbound peers for P2P |
| CONFIG__P2P_MAX_OUTBOUND_PEERS | 10 | Maximum outbound peers for P2P |
| CONFIG__P2P_UNCOND_PEERS | "" | Unconditional peers for P2P |
| CONFIG__P2P_MAX_DIAL_PPEERS | "0s" | Maximum dial period per peers for P2P |
| CONFIG__P2P_FLUSH_TIMEOUT | "100ms" | Flush timeout for P2P |
| CONFIG__P2P_MAX_PAYLOAD_SIZE | 1024 | Maximum payload size for P2P |
| CONFIG__P2P_SENDRATE | 5120000 | Send rate for P2P |
| CONFIG__P2P_RCVRATE | 5120000 | Receive rate for P2P |
| CONFIG__P2P_PEX_ENABLED | true | Peer-exchange enabled for P2P |
| CONFIG__P2P_SEED_MODE_ENABLED | false | Seed mode enabled for P2P |
| CONFIG__P2P_PRIV_PEERS | "" | Private peers for P2P |
| CONFIG__P2P_ALLOW_DUP_IP | false | Allow duplicate IP for P2P |
| CONFIG__P2P_HANDSHAKE_TIMEOUT | "20s" | Handshake timeout for P2P |
| CONFIG__P2P_DIAL_TIMEOUT | "3s" | Dial timeout for P2P |
| CONFIG__MEMPOOL_VERSION | "v0" | Mempool version |
| CONFIG__MEMPOOL_RECHECK | true | Mempool recheck |
| CONFIG__MEMPOOL_BROADCAST_ENABLED | true | Mempool broadcast enabled |
| CONFIG__MEMPOOL_WAL_DIR | "" | Mempool WAL directory |
| CONFIG__MEMPOOL_TX_MAX_COUNT | 5000 | Maximum transaction count for mempool |
| CONFIG__MEMPOOL_TX_MAX_SIZE | 1073741824 | Maximum transaction size for mempool |
| CONFIG__MEMPOOL_CACHE_SIZE | 10000 | Cache size for mempool |
| CONFIG__MEMPOOL_TX_INVALID_CACHE_ENABLED | false | Invalid transaction cache enabled for mempool |
| CONFIG__MEMPOOL_TX_SINGLE_SIZE | 1048576 | Single transaction size for mempool |
| CONFIG__MEMPOOL_TX_BATCH_SIZE | 0 | Transaction batch size for mempool |
| CONFIG__MEMPOOL_TX_TTL_TIME | "0s" | Transaction TTL time for mempool |
| CONFIG__MEMPOOL_TX_TTL_BLOCKS | 0 | Transaction TTL blocks for mempool |
| CONFIG__STATESYNC_ENABLED | false | State sync enabled |
| CONFIG__STATESYNC_RPC_SERVERS | "" | RPC servers for state sync |
| CONFIG__STATESYNC_TRUST_HEIGHT | 0 | Trust height for state sync |
| CONFIG__STATESYNC_TRUST_HASH | "" | Trust hash for state sync |
| CONFIG__STATESYNC_TRUST_PERIOD | "168h0m0s" | Trust period for state sync |
| CONFIG__STATESYNC_DISCOVERY_TIME | "15s" | Discovery time for state sync |
| CONFIG__STATESYNC_TEMP_DIR | "" | Temp directory for state sync |
| CONFIG__STATESYNC_CHUNK_TIMEOUT | "10s" | Chunk timeout for state sync |
| CONFIG__STATESYNC_CHUNK_FETCH_COUNT | "4" | Chunk fetch count for state sync |
| CONFIG__FSYNC_VERSION | "v0" | Fsync version |
| CONFIG__CONSENSUS_WAL_PATH | "data/cs.wal/wal" | Consensus WAL path |
| CONFIG__CONSENSUS_PROPOSE_TIMEOUT | "3s" | Propose timeout for consensus |
| CONFIG__CONSENSUS_PROPOSE_DELTA | "500ms" | Propose delta for consensus |
| CONFIG__CONSENSUS_PREVOTE_TIMEOUT | "1s" | Prevote timeout for consensus |
| CONFIG__CONSENSUS_PREVOTE_DELTA | "500ms" | Prevote delta for consensus |
| CONFIG__CONSENSUS_PRECOMMIT_TIMEOUT | "1s" | Precommit timeout for consensus |
| CONFIG__CONSENSUS_PRECOMMIT_DELTA | "500ms" | Precommit delta for consensus |
| CONFIG__CONSENSUS_COMMIT_TIMEOUT | "5s" | Commit timeout for consensus |
| CONFIG__CONSENSUS_DSIGN_CHECK_HEIGHT | 0 | Double sign check height for consensus |
| CONFIG__CONSENSUS_COMMIT_SKIP_TIMEOUT | false | Commit skip timeout for consensus |
| CONFIG__CONSENSUS_BLOCK_CREATE_EMPTY_ENABLED | true | Block create empty enabled for consensus |
| CONFIG__CONSENSUS_BLOCK_CREATE_EMPTY_INTERVAL | "0s" | Block create empty interval for consensus |
| CONFIG__CONSENSUS_PEER_GOSSIP_SLEEP | "100ms" | Peer gossip sleep for consensus |
| CONFIG__CONSENSUS_PEER_QUERY_SLEEP | "2s" | Peer query sleep for consensus |
| CONFIG__CONSENSUS_ABCI_DISCARD_RESPONSE_ENABLED | false | ABCI discard response enabled for consensus |
| CONFIG__INDEXER_TYPE | "null" | Indexer type |
| CONFIG__INDEXER_PSQL_CONN | "" | PostgreSQL connection for indexer |
| CONFIG__PROMETHEUS_ENABLED | false | Prometheus enabled |
| CONFIG__PROMETHEUS_LADDR | ":26660" | Prometheus local address |
| CONFIG__PROMETHEUS_MAX_CONN | 3 | Maximum connections for Prometheus |
| CONFIG__PROMETHEUS_NAMESPACE | "tendermint" | Prometheus namespace |

## Client.toml

Here are the environment variables for the client configuration.

| Environment Variable | Value | Description |
|----------------------|-------|-------------|
| CLIENT__CHAIN_ID | "CHAIN-ID" | Chain ID |
| CLIENT__KEYRING_BACKEND | "os" | Keyring backend |
| CLIENT__CLI_OUTPUT | "json" | CLI output format |
| CLIENT__TENDERMINT_RPC_ADDR | "tcp://localhost:26657" | Tendermint RPC Address |
| CLIENT__BROADCAST_MODE | "sync" | Broadcast mode |
