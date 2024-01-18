import os
import requests
import datetime
from ruamel.yaml import YAML

# Set the constants
REPO = "chainroot"
ROOT_PATH = "."

def log(message):
    print(f"[LOG] {datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')}: {message}")

def fetch_latest_version(repo_url):
    log(f"Fetching latest version from: {repo_url}")
    try:
        response = requests.get(repo_url)
        response.raise_for_status()
        latest_version = response.json()[0]['tag_name']
        log(f"Fetched latest binary version: {latest_version}")
        return latest_version
    except requests.RequestException as e:
        log(f"Error fetching latest version from {repo_url}: {e}")
        return None

def update_docker_compose_image(network, new_version):
    docker_compose_path = os.path.join(network, 'docker-compose.yml')
    try:
        yaml = YAML()
        yaml.preserve_quotes = True
        yaml.indent(mapping=2, sequence=4, offset=2)
        with open(docker_compose_path, 'r') as file:
            compose_data = yaml.load(file)

        current_image = compose_data['services'][network]['image']
        new_image = f"chainroot/{network}:{new_version}"

        if current_image != new_image:
            compose_data['services'][network]['image'] = new_image
            
            with open(docker_compose_path, 'w') as file:
                yaml.dump(compose_data, file)

            log(f"Docker image updated to {new_image} in docker-compose.yml for {network}")
        else:
            log(f"No update required for docker-compose.yml of {network}")

    except Exception as e:
        log(f"Error updating docker-compose.yml for {network}: {e}")
        
def update_version_file(dir_path, new_versions):
    # """
    # Update the VERSION file if any of the versions have changed.

    # :param dir_path: The directory path where the VERSION file is located.
    # :param new_versions: A dictionary containing the new 'binary', 'go', and 'wasm' versions.
    # """
    version_file_path = os.path.join(dir_path, 'VERSION')
    current_versions = {'binary': None, 'go': None, 'wasm': None}

    # Read current versions from the VERSION file if it exists
    if os.path.exists(version_file_path):
        with open(version_file_path, 'r') as file:
            for line in file:
                if 'binary' in line:
                    current_versions['binary'] = line.split()[1]
                elif 'go' in line:
                    current_versions['go'] = line.split()[1]
                elif 'wasm' in line:
                    current_versions['wasm'] = line.split()[1]

    # Compare and update if there are any changes
    if any(current_versions[key] != new_versions[key] for key in current_versions):
        with open(version_file_path, 'w') as file:
            file.write(f"binary {new_versions['binary']}\n")
            file.write(f"go {new_versions['go']}\n")
            if new_versions['wasm']:
                file.write(f"wasm {new_versions['wasm']}\n")
        print(f"VERSION file updated for {dir_path}")
    else:
        print(f"No update required for {dir_path}")


def find_directories(root_path):
    directories = []
    filename = "Dockerfile"
    try:
        for dir in os.listdir(root_path):
            dir_path = os.path.join(root_path, dir)
            if os.path.isdir(dir_path) and filename in os.listdir(dir_path):
                directories.append(dir)
        log(f"Found Networks: {directories}")
    except OSError as e:
        log(f"Error accessing directory {root_path}: {e}")
    return directories


def get_go_and_wasm_versions(repo_part, binary_version):
    # """
    # Fetch Go and Wasm versions from the go.mod file of the specified binary version.

    # :param repo_part: The repository path mentioned in the info file.
    # :param binary_version: The detected binary version.
    # :return: A tuple containing the Go version and Wasm version (if exists).
    # """
    go_version = wasm_version = None
    go_mod_url = f"https://raw.githubusercontent.com/{repo_part}/{binary_version}/go.mod"

    try:
        response = requests.get(go_mod_url)
        response.raise_for_status()
        go_mod_content = response.text

        for line in go_mod_content.splitlines():
            if line.startswith("go "):
                go_version = line.split()[1]
            elif "github.com/CosmWasm/wasmvm" in line:
                wasm_version = line.split()[1]

    except requests.RequestException as e:
        print(f"Error fetching go.mod file from {go_mod_url}: {e}")

    return go_version, wasm_version

def main():
    log(f"Starting version check for repo: {REPO} in root path: {ROOT_PATH}")
    base_url = "https://api.github.com/repos"
    networks = find_directories(ROOT_PATH)

    for network in networks:
        try:
            info_path = os.path.join(ROOT_PATH, network, 'info')
            with open(info_path) as info_file:
                repo_part = info_file.read().strip()
            repo_url = f"{base_url}/{repo_part}/releases"

            latest_version = fetch_latest_version(repo_url)
            if latest_version is None:
                log(f"Skipping network {network} due to fetch error")
                continue

            go_version, wasm_version = get_go_and_wasm_versions(repo_part, latest_version)
            log(f"Extracted Go version: {go_version}, Wasm version: {wasm_version}")

            new_versions = {
                'binary': latest_version,
                'go': go_version,
                'wasm': wasm_version
            }
            update_version_file(network, new_versions)

            # Check and update docker-compose.yml independently
            update_docker_compose_image( network, latest_version)

        except IOError as e:
            log(f"Error reading info file for {network}: {e}")
        except Exception as e:
            log(f"Unexpected error processing network {network}: {e}")

if __name__ == "__main__":
    main()
