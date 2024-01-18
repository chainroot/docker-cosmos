# Docker-Cosmos

## Introduction

Welcome to Docker-Cosmos, a repository managed by [chainroot](https://github.com/chainroot) for deploying and managing Docker containers for various Cosmos-based blockchain networks. This repository automates the process of version management and Docker image deployment, ensuring that each network runs the latest version of its respective blockchain software.

## Features

- **Automated Version Management**: Automatically fetches and updates the versions of blockchain networks.
- **Docker Support**: Each network has its Docker configuration for easy setup and deployment.
- **Scalability**: Designed to support and manage multiple blockchain networks.
- **CI/CD Integration**: Utilizes GitHub Actions for continuous integration and deployment.
- **Comprehensive Logging and Error Handling**: Ensures smooth operation and ease of troubleshooting.

## Prerequisites

Before you begin, ensure you have the following installed:
- Docker
- Docker Compose
- Python 3
- [ruamel.yaml](https://pypi.org/project/ruamel.yaml/) Python package

## Setup

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/chainroot/docker-cosmos.git
   cd docker-cosmos
   ```

2. **Install Python Dependencies**:
   ```bash
   pip install -r requirements.txt
   ```

## Usage

### Updating Versions

To update the versions of the blockchain networks to the latest state:

```bash
make check_version
```

This command runs the `check_version.py` script, which checks for the latest versions of each network and updates the `VERSION` file and `docker-compose.yml` files accordingly.

### Building Docker Images

To build Docker images for all networks:

```bash
make buildall
```

To build a Docker image for a specific network (e.g., `cosmos`):

```bash
make build DIR=cosmos
```

### Pushing Docker Images

To push Docker images for all networks:

```bash
make pushall
```

To push a Docker image for a specific network:

```bash
make push DIR=cosmos
```

### Running Tests

To run tests for all Docker images:

```bash
make test
```

### Cleaning Up

To remove Docker images:

```bash
make clean
```

## Contributing

Contributions to Docker-Cosmos are welcome! Please read our [Contributing Guide](CONTRIBUTING.md) for details on how to contribute.

## License

This project is licensed under the [MIT License](LICENSE).
