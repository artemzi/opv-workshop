all: push

BUILDTAGS=

APP?=opv-workshop
CHARTS?=mycharts
USERSPACE?=artemzi
HELM_REPO?=https://${USERSPACE}.github.io/${CHARTS}
RELEASE?=0.1.0
PROJECT?=github.com/${USERSPACE}/${APP}
GOOS?=linux
REGISTRY?=registry.${USERSPACE}.${APP}
SERVICE_PORT?=8080

NAMESPACE?=dev
PREFIX?=${REGISTRY}/${NAMESPACE}/${APP}
CONTAINER_NAME?=${APP}-${NAMESPACE}

ifeq ($(NAMESPACE), default)
	PREFIX=${REGISTRY}/${APP}
	CONTAINER_NAME=${APP}
endif

REPO_INFO=$(shell git config --get remote.origin.url)

ifndef COMMIT
	COMMIT := git-$(shell git rev-parse --short HEAD)
endif

vendor: clean
	go get -u github.com/golang/dep \
	&& dep ensure

build: vendor
	CGO_ENABLED=0 GOOS=${GOOS} go build -a -installsuffix cgo \
		-ldflags "-s -w -X ${PROJECT}/version.RELEASE=${RELEASE} -X ${PROJECT}/version.COMMIT=${COMMIT} -X ${PROJECT}/version.REPO=${REPO_INFO}" \
		-o ${APP}

container: build
	docker build --no-cache --pull -t $(APP):$(RELEASE) .

push: container
	docker push $(PREFIX):$(RELEASE)

run: container
	docker run --name ${CONTAINER_NAME} -p ${SERVICE_PORT}:${SERVICE_PORT} \
		-e "SERVICE_PORT=${SERVICE_PORT}" \
		-d $(APP):$(RELEASE)

deploy: push
	helm repo add ${USERSPACE} ${HELM_REPO} \
	&& helm repo up \
	&& helm upgrade ${CONTAINER_NAME} ${USERSPACE}/${APP} --namespace ${NAMESPACE} --set image.tag=${RELEASE} -i --wait

fmt:
	@echo "+ $@"
	@go list -f '{{if len .TestGoFiles}}"gofmt -s -l {{.Dir}}"{{end}}' $(shell go list ${PROJECT}/... | grep -v vendor) | xargs -L 1 sh -c

lint:
	@echo "+ $@"
	@go list -f '{{if len .TestGoFiles}}"golint {{.Dir}}/..."{{end}}' $(shell go list ${PROJECT}/... | grep -v vendor) | xargs -L 1 sh -c

vet:
	@echo "+ $@"
	@go vet $(shell go list ${PROJECT}/... | grep -v vendor)

test: vendor fmt lint vet
	@echo "+ $@"
	@go test -v -race -tags "$(BUILDTAGS) cgo" $(shell go list ${PROJECT}/... | grep -v vendor)

cover:
	@echo "+ $@"
	@go list -f '{{if len .TestGoFiles}}"go test -coverprofile={{.Dir}}/.coverprofile {{.ImportPath}}"{{end}}' $(shell go list ${PROJECT}/... | grep -v vendor) | xargs -L 1 sh -c

clean:
	rm -f ${APP}