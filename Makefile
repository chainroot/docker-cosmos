SHELL = /bin/bash -e

.PHONY: lint
lint:
	find . -type f -name 'Dockerfile' -not -path "./.git/*" | while read -r file; do \
		echo "****> Linting Dockerfile in directory: $$(dirname "$$file")"; \
		docker run --rm -i hadolint/hadolint < "$$file" || true; \
	done

.PHONY: build
build:
	@echo "****> Building Docker image in directory: $(DIR)"; \
	DIR_NAME=$$(basename $(DIR)); \
	IMAGE_NAME="chainroot/$$DIR_NAME"; \
	BRANCH_NAME=$$(git rev-parse --abbrev-ref HEAD); \
	TAGS="$$IMAGE_NAME:$$BRANCH_NAME"; \
	if [[ "$$BRANCH_NAME" == "main" ]]; then \
		TAGS="$$IMAGE_NAME:latest"; \
	fi; \
	pushd $(DIR); \
	docker buildx build -t $$TAGS -f Dockerfile .; \
	popd

.PHONY: push
push:
	@echo "****> Pushing Docker image in directory: $(DIR)"; \
	DIR_NAME=$$(basename $(DIR)); \
	IMAGE_NAME="chainroot/$$DIR_NAME"; \
	BRANCH_NAME=$$(git rev-parse --abbrev-ref HEAD); \
	TAGS="$$IMAGE_NAME:$$BRANCH_NAME"; \
	if [[ "$$BRANCH_NAME" == "main" ]]; then \
		TAGS="$$IMAGE_NAME:latest"; \
	fi; \
	docker push $$TAGS

.PHONY: buildall
buildall:
	find . -type f -name 'Dockerfile' -not -path "./.git/*" | while read -r file; do \
		make build DIR=$$(dirname "$$file"); \
	done

.PHONY: pushall
pushall:
	find . -type f -name 'Dockerfile' -not -path "./.git/*" | while read -r file; do \
		make push DIR=$$(dirname "$$file"); \
	done

.PHONY: clean
clean:
	@echo "****> Removing Docker image in directory: $(DIR)"; \
	DIR_NAME=$$(basename $(DIR)); \
	IMAGE_NAME="chainroot/$$DIR_NAME"; \
	BRANCH_NAME=$$(git rev-parse --abbrev-ref HEAD); \
	TAGS="$$IMAGE_NAME:$$BRANCH_NAME"; \
	if [[ "$$BRANCH_NAME" == "main" ]]; then \
		TAGS="$$IMAGE_NAME:latest"; \
	fi; \
	docker rmi $$TAGS

.PHONY: test
test:
	@echo "****> Testing Docker image in directory: $(DIR)"; \
	DIR_NAME=$$(basename $(DIR)); \
	IMAGE_NAME="chainroot/$$DIR_NAME"; \
	BRANCH_NAME=$$(git rev-parse --abbrev-ref HEAD); \
	TAGS="$$IMAGE_NAME:$$BRANCH_NAME"; \
	if [[ "$$BRANCH_NAME" == "main" ]]; then \
		TAGS="$$IMAGE_NAME:latest"; \
	fi; \
	docker run -d --name test $$TAGS; \
	docker ps | grep test

.PHONY: help
help:
	@echo "Available targets:"
	@echo "  lint      - Lint Dockerfiles"
	@echo "  build     - Build Docker image"
	@echo "  push      - Push Docker image"
	@echo "  buildall  - Build all Docker images"
	@echo "  pushall   - Push all Docker images"
	@echo "  clean     - Remove Docker image"
	@echo "  test      - Test Docker image"
	@echo "  help      - Display this help message"

.PHONY: all
all: lint buildall
