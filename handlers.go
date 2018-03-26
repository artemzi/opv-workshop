package main

import (
	"fmt"

	"github.com/artemzi/opv-workshop/version"
	"github.com/takama/router"
)

func home(c *router.Control) {
	fmt.Fprintf(c.Writer, "Repo: %s, Commit: %s, Version: %s\n",
		version.REPO, version.COMMIT, version.RELEASE)
}

func logger(c *router.Control) {
	remoteAddr := c.Request.Header.Get("X-Forwarded-For")
	if remoteAddr == "" {
		remoteAddr = c.Request.RemoteAddr
	}
	log.Infof("%s %s %s", remoteAddr, c.Request.Method, c.Request.URL.Path)
}
