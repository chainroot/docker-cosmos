SHELL = /bin/bash -e

# common variables
REPO := chainroot
DIRS := $(shell ls */Dockerfile | xargs dirname)
BRANCH_NAME := $(shell git symbolic-ref -q --short HEAD)


ifeq ($(BRANCH_NAME), main)
    VERSION := $(shell cat ./$(DIR)/VERSION | grep binary | awk '{print $$2}')
    DOCKER_TAGS := $(foreach version, $(VERSION), -t $(REPO)/$(DIR):$(version))
    DOCKER_TAGS += -t $(REPO)/$(DIR):latest
else
    DOCKER_TAGS := -t $(REPO)/$(DIR):$(BRANCH_NAME)
endif


# Define a function to get version values
define get_versions
$(eval GO_VERSION := $(shell cat ./$1/VERSION | grep go | awk '{print $$2}'))
$(eval BIN_VERSION := $(shell cat ./$1/VERSION | grep binary | awk '{print $$2}'))
$(eval WASM_VERSION := $(shell cat ./$1/VERSION | grep wasm | awk '{print $$2}'))
# Use shell conditional logic to set BUILD_ARG
$(eval BUILD_ARG := --build-arg GO_VERSION=$(GO_VERSION) --build-arg BIN_VERSION=$(BIN_VERSION) $(if $(WASM_VERSION), --build-arg WASM_VERSION=$(WASM_VERSION)))
$(eval DOCKER_CMD := docker buildx build $(DOCKER_TAGS) $(BUILD_ARG) .)
endef



.PHONY: lint
lint:
	@$(info ****> Linting $(DIRS))
	@for dir in $(DIRS); do \
		$(info ****> Linting Dockerfiles in $$dir) \
		docker run --rm -i hadolint/hadolint \
		  hadolint --no-fail - < $$dir/Dockerfile; \
	done

.PHONY: build
build:
	  @$(call get_versions,$(DIR))
		@$(info ****> Building $(DIR) -- $(REPO)/$(DIR):$(BRANCH_NAME) -- $(DOCKER_CMD))
		@pushd $(DIR) && $(DOCKER_CMD) && popd

.PHONY: buildall
buildall: $(addprefix build-, $(DIRS))

build-%:
	@$(MAKE) build DIR=$*

.PHONY: push
push:
	@$(info ****> Pushing $(DIR) -- $(REPO)/$(DIR):$(BRANCH_NAME))
	@$(call get_versions,$(DIR))
	@pushd $(DIR) && $(DOCKER_CMD) --push && popd

.PHONY: pushall
pushall: $(addprefix push-, $(DIRS))

push-%:
	@$(MAKE) push DIR=$*

.PHONY: clean
clean:
	@$(info ****> Removing $(DIR) -- $(REPO)/$(DIR):$(BRANCH_NAME))
	@docker rmi -f $(REPO)/$(DIR):$(BRANCH_NAME)

.PHONY: test
test:
	@$(info ****> Testing $(DIR) -- $(REPO)/$(DIR):$(BRANCH_NAME))
	@docker run --rm --name $(BRANCH_NAME) $(REPO)/$(DIR):$(BRANCH_NAME)

.PHONY: help
help:
.PHONY: help
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

.PHONY: all
all: buildall

.PHONY: checkversion
checkversion:
	python3 check_version.py