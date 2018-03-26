package main

import (
	"fmt"

	"github.com/takama/router"
)

func home(c *router.Control) {
	fmt.Fprintf(c.Writer, "Processing URL: %s...", c.Request.URL.Path)
}
