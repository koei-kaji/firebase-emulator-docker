
DOCKER_TAG=firebase-emulator:0.1.0

.PHONY: lint
lint:
	@hadolint ./Dockerfile

.PHONY: build
build:
	@docker build --no-cache -t $(DOCKER_TAG) .

.PHONY: scan
scan:
	@dockle $(DOCKER_TAG)
	@trivy image --ignore-unfixed $(DOCKER_TAG)

pre-commit: lint build scan

.PHONY: run
run:
	@docker run --rm \
	  -p 4000:4000 \
	  -p 8080:8080 \
	  -p 8085:8085 \
	  -p 9000:9000 \
	  -p 9099:9099 \
	  -p 9199:9199 \
	  $(DOCKER_TAG)