SHELL = /bin/bash -e

# Common variables
DIRS := $(shell ls */Dockerfile | xargs dirname)
IMAGE_NAME = chainroot/$$DIR
BRANCH_NAME := $(shell git symbolic-ref -q --short HEAD)

# set TAG to git tag if it exists, otherwise use branch name. use latest for main branch.
TAG ?= $(shell git describe --tags --exact-match 2>/dev/null || ([ "$(BRANCH_NAME)" = "main" ] && echo latest || echo $(BRANCH_NAME)))


.PHONY: lint
lint:
	@echo "****> Linting Dockerfiles"
	@for dir in $(DIRS); do \
		echo "****> Linting Dockerfile for $$dir; \
		docker run --rm -i hadolint/hadolint < "$$dir/Dockerfile" || true; \
	done

.PHONY: build
build:
	@echo "****> Building $(DIR) -- $(IMAGE_NAME):$(TAG)"
	@pushd $(DIR) && docker buildx build -t $(IMAGE_NAME):$(TAG) -f Dockerfile . && popd

.PHONY: push
push:
	@echo "****> Pushing $(DIR) -- $(IMAGE_NAME):$(TAG)"
	@docker push $(IMAGE_NAME):$(TAG)

.PHONY: buildall
buildall:
	@echo "****> Building: $(DIRS)"
	@for dir in $(DIRS); do \
		make build DIR=$$dir; \
	done

.PHONY: pushall
pushall:
	@echo "****> Pushing: $(DIRS)"
	@for dir in $(DIRS); do \
		make push DIR=$$dir; \
	done

.PHONY: clean
clean:
	@echo "****> Removing $(DIR) -- $(IMAGE_NAME):$(TAG)"
	@docker rmi $(IMAGE_NAME):$(TAG)

.PHONY: test
test:
	@echo "****> Testing $(DIR) -- $(IMAGE_NAME):$(TAG)"
	@docker run --rm --name $(TAG) $(IMAGE_NAME):$(TAG)

.PHONY: help
help:
	@echo "Available targets:"
	@echo "  lint      - Lint Dockerfiles"
	@echo "  build     - Build Docker image"
	@echo "  push      - Push Docker image"
	@echo "  buildall  - Build all Docker images"
	@echo "  pushall   - Push all Docker images"
	@echo "  clean     - Remove Docker image"
	@echo "  help      - Display this help message"

.PHONY: all
all: lint buildall
