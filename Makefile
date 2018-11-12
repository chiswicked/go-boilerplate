BASE_PATH			:= $(abspath $(lastword $(MAKEFILE_LIST)))
BASE_DIR			:= $(notdir $(patsubst %/,%,$(dir $(BASE_PATH))))

ORG					?= chiswicked
SERVICE				?= $(BASE_DIR)
DOCKER_IMAGE		:= $(ORG)/$(SERVICE)
VERSION				?= $(shell cat $(BASE_PATH)/VERSION 2> /dev/null || echo 0.0.1)

# Local commands

.PHONY: all clean clean-cover install build test cover docker-build

all: clean install test build

clean: clean-cover
	go clean
	rm -f $(SERVICE)

clean-cover:
	rm -f cover.out cover.html

install:
	go get -v -t -d ./...

build: clean
	go build -o build/$(SERVICE) -a .

test:
	go test -v -cover ./...

cover: clean-cover
	go test -coverprofile cover.out ./...
	go tool cover -html=cover.out -o cover.html
	open cover.html

docker-build:
	docker build -t $(DOCKER_IMAGE):local . --build-arg SERVICE=$(SERVICE)

# CI commands

.PHONY: ci-docker-auth ci-docker-build ci-docker-push

ci-docker-auth:
	@docker login -u $(DOCKER_USERNAME) -p $(DOCKER_PASSWORD)

ci-docker-build:
	docker build -t $(DOCKER_IMAGE):$(VERSION) . --build-arg SERVICE=$(SERVICE)

ci-docker-push: ci-docker-auth
	docker tag $(DOCKER_IMAGE):$(VERSION) $(DOCKER_IMAGE):latest
	docker push $(DOCKER_IMAGE)
