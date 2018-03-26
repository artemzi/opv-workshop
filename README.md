# nil

Set variables for running it localy with:
> export SERVICE_PORT="8000"

```Bash
go test -v && env CGO_ENABLED=0 GOOS=linux go build -o app .
docker build -t app-workshop -f ./Dockerfile .
docker run -p 8000:8000 app-workshop
```