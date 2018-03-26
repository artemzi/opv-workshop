all: push

BUILDTAGS=

APP?=opv-workshop
USERSPACE?=artemzi
RELEASE?=0.0.1
PROJECT?=github.com/${USERSPACE}/${APP}
GOOS?=linux
SERVICE_PORT?=8000

NAMESPACE?=artemzi
PREFIX?=${REGISTRY}/${NAMESPACE}/${APP}
CONTAINER_NAME?=${APP}-${NAMESPACE}

REPO_INFO=$(shell git config --get remote.origin.url)

ifndef COMMIT
	COMMIT := git-$(shell git rev-parse --short HEAD)
endif

vendor: clean
	go get -u github.com/golang/dep \
	&& dep ensure

build: vendor
	env CGO_ENABLED=0 GOOS=linux go build -o $(APP) .

container: build
	docker build -t $(APP):$(RELEASE) -f ./Dockerfile .

run:
	docker run -p 8000:8000 $(APP):$(RELEASE)

clean:
	rm -f ${APP}