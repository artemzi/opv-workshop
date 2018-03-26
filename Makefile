all: push

BUILDTAGS=

APP?=opv-workshop
USERSPACE?=artemzi
RELEASE?=0.0.1
PROJECT?=github.com/${USERSPACE}/${APP}
SERVICE_PORT?=8080

REPO_INFO=$(shell git config --get remote.origin.url)

ifndef COMMIT
	COMMIT := git-$(shell git rev-parse --short HEAD)
endif

vendor: clean
	go get -u github.com/golang/dep \
	&& dep ensure

build: vendor
	env CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo \
	-ldflags "-s -w -X ${PROJECT}/version.RELEASE=${RELEASE} -X ${PROJECT}/version.COMMIT=${COMMIT} -X ${PROJECT}/version.REPO=${REPO_INFO}" \
	-o ${APP}

container: build
	docker build --no-cache -t $(APP):$(RELEASE) -f ./Dockerfile .
	docker images

run:
	docker run -p ${SERVICE_PORT}:${SERVICE_PORT} \
	-e "SERVICE_PORT=${SERVICE_PORT}" \
	-d $(APP):$(RELEASE)

clean:
	rm -f ${APP}