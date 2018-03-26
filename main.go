package main

import "github.com/takama/router"

func main() {
	r := router.New()
	r.GET("/", home)
	r.Listen(":8000")
}
