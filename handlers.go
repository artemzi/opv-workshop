package main

import (
	"fmt"

	"github.com/takama/router"
)

func home(c *router.Control) {
	fmt.Fprintf(c.Writer, "Processing URL: %s...", c.Request.URL.Path)
}

func logger(c *router.Control) {
	remoteAddr := c.Request.Header.Get("X-Forwarded-For")
	if remoteAddr == "" {
		remoteAddr = c.Request.RemoteAddr
	}
	log.Infof("%s %s %s", remoteAddr, c.Request.Method, c.Request.URL.Path)
}
