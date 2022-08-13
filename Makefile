
include default.env

.PHONY: lint
lint:
	@hadolint ./Dockerfile

.PHONY: build
build:
	@docker build --no-cache -t $(DOCKER_TAG) .

.PHONY: scan
scan:
	@docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
		goodwithtech/dockle:latest --no-color $(DOCKER_TAG)
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