package main

import (
	"github.com/go-macaron/pongo2"
	"gopkg.in/macaron.v1"

	"./ctl"
)

func main() {
	m := macaron.Classic()
	m.Use(pongo2.Pongoer())
	m.Use(macaron.Static("/root/Doc/bin/public"))
	// m.Use(macaron.Static("~/Document/git/TodayHistory/TodayServer/public"))

	m.Get("/", func(ctx *macaron.Context) {
		ctx.Redirect("/main")
	})
	m.Post("/uploadreadprocess", ctl.UploadReadprocess)
	m.Put("/uploadreadprocess", ctl.UploadReadprocess)
	m.Get("/readprocess", ctl.ReadprocessGet)

	m.Run("0.0.0.0", 8088)
}
