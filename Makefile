SHELL = /bin/bash -e

# common variables
REPO := chainroot
DIRS := cosmos osmosis stride terra
BRANCH_NAME := $(shell git symbolic-ref -q --short HEAD)

# Function to get version information
define get_version
$(shell cat $(1)/VERSION | grep $(2) | awk '{print $$2}')
endef

# DOCKER_TAGS configuration
ifeq ($(BRANCH_NAME), main)
    DOCKER_TAGS := $(foreach dir, $(DIRS), -t $(REPO)/$(dir):$(call get_version,$(dir),binary))
    DOCKER_TAGS += -t $(REPO)/$(dir):latest
else
    DOCKER_TAGS := $(foreach dir, $(DIRS), -t $(REPO)/$(dir):$(BRANCH_NAME))
endif

# Build arguments
define build_arg
--build-arg GO_VERSION=$(call get_version,$(1),go) \
--build-arg BIN_VERSION=$(call get_version,$(1),binary) \
$(if $(call get_version,$(1),wasm),--build-arg WASM_VERSION=$(call get_version,$(1),wasm))
endef

DOCKER_CMD := docker buildx build $(DOCKER_TAGS) $(call build_arg,$(DIR)) .

# Targets
.PHONY: lint build push buildall pushall clean test help all checkversion

lint:
	@$(info ****> Linting $(DIRS))
	@for dir in $(DIRS); do \
		$(info ****> Linting Dockerfiles in $$dir) \
		docker run --rm -i hadolint/hadolint \
		  hadolint --no-fail - < $$dir/Dockerfile; \
	done

build:
	@$(info ****> Building $(DIR) -- $(REPO)/$(DIR):$(BRANCH_NAME))
	@pushd $(DIR) && $(DOCKER_CMD) && popd

push:
	@$(info ****> Pushing $(DIR) -- $(REPO)/$(DIR):$(BRANCH_NAME))
	@pushd $(DIR) && $(DOCKER_CMD) --push && popd

buildall: $(addprefix build-, $(DIRS))

build-%:
	@$(MAKE) build DIR=$*

pushall: $(addprefix push-, $(DIRS))

push-%:
	@$(MAKE) push DIR=$*

clean:
	@$(info ****> Removing $(DIR) -- $(REPO)/$(DIR):$(BRANCH_NAME))
	@docker rmi -f $(REPO)/$(DIR):$(BRANCH_NAME)

test:
	@$(info ****> Testing $(DIR) -- $(REPO)/$(DIR):$(BRANCH_NAME))
	@docker run --rm --name $(BRANCH_NAME) $(REPO)/$(DIR):$(BRANCH_NAME)

help:
	@echo "Available targets:"
	@echo "  lint      - Lint Dockerfiles in each directory"
	@echo "  build     - Build Docker image for a specified DIR (e.g., make build DIR=cosmos)"
	@echo "  push      - Build and push Docker image for a specified DIR (e.g., make push DIR=cosmos)"
	@echo "  buildall  - Build Docker images for all directories"
	@echo "  pushall   - Build and push Docker images for all directories"
	@echo "  clean     - Remove Docker image for a specified DIR"
	@echo "  test      - Run Docker image for a specified DIR"
	@echo "  help      - Display this help message"
	@echo "  all       - Run buildall target"

all: buildall

checkversion:
	.github/workflows/update_version.sh $(REPO) $(DIRS)
