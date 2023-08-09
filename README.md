# Docker-Cosmos

Welcome to Docker-Cosmos, a repository containing configurations for running multiple Cosmos based networks as Docker containers. Each network configuration resides in a separate folder, equipped with its own Docker Compose and .env sample file preconfigured with default values.

The configurations are organized in three categories, namely `APP`, `CLIENT`, and `CONFIG`, each represented with corresponding environment variables. The structured naming convention of the variables, using double underscores as separators, helps in organizing and identifying the settings with ease, providing a hierarchical perspective to the configuration options.

## Environment Variables

Detailed tables representing each environment variable, along with their descriptions and default values, can be found in the README.md file within each network's directory.

Before starting a container, ensure to customize the `SNAPSHOT_BLOCK_HEIGHT` and `CONFIG__MONIKER_NAME` variables according to your specific requirements. These variables are crucial for correct network operation and must be set appropriately.

## Docker Setup

Docker Compose files are provided to simplify the process of setting up each Cosmos network software. 

### Prerequisites

Ensure Docker and Docker Compose are installed on your machine. If not, follow the official Docker installation guide [here](https://docs.docker.com/get-docker/) and Docker Compose installation guide [here](https://docs.docker.com/compose/install/).

### Usage

Each Docker Compose file runs the latest version of the Cosmos network Docker image, maps the necessary ports, and mounts a volume to persist data.

Follow these steps to get your container running:

1. Clone the repository:

```bash
git clone https://github.com/chainroot/docker-cosmos.git
```

2. Navigate into the directory of the desired network:

```bash
cd docker-cosmos/<network_directory>
```

3. Edit the `.env` file and set your desired values for the environment variables, particularly `SNAPSHOT_BLOCK_HEIGHT` and `CONFIG__MONIKER_NAME`.

4. Run the Docker Compose command:

```bash
docker-compose up -d
```

This will start the Cosmos network software in a Docker container, with the network being accessible at ports 26656 and 26657. The `-d` flag tells Docker to run the container in the background.

## Contributing

Contributions are what make the open-source community such an amazing place to learn, inspire, and create. Any contributions you make are greatly appreciated. If you have a suggestion that would make this better, please fork the repo and create a pull request. 