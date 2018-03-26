package main

import (
	"os"

	"github.com/Sirupsen/logrus"
	"github.com/takama/router"
)

var log = logrus.New()

func main() {
	host := ":"
	port := os.Getenv("SERVICE_PORT")
	if len(port) == 0 {
		log.Fatal("Service port is not set")
	}

	r := router.New()
	r.Logger = logger
	r.GET("/", home)
	r.Listen(host + port)
}
