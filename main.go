package main

import (
	"github.com/Sirupsen/logrus"
	"github.com/takama/router"
)

var log = logrus.New()

func main() {
	r := router.New()
	r.Logger = logger
	r.GET("/", home)
	r.Listen(":8000")
}
