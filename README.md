# nil

Set variables for running it localy with:
> export SERVICE_PORT="8000"

```Bash
go test -v && env CGO_ENABLED=0 GOOS=linux go build -o opv-workshop .
docker build -t opv-workshop -f ./Dockerfile .
docker run -p 8000:8000 opv-workshop
```

## Check list

- repository setup
- minimal web server and tests
- router
- logging
- dependecy managment
- configuration
- dockerisation
- release info and health check
- graceful shutdown
- makefile with cmd helpers