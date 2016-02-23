package main

import (
	"./ctl"
	"github.com/go-macaron/pongo2"
	"gopkg.in/macaron.v1"
)

func main() {
	m := macaron.Classic()
	m.Use(pongo2.Pongoer())

	m.Post("/uploadreadprocess", ctl.UploadReadprocess)
	m.Get("/uploadreadprocess", ctl.UploadReadprocessGet)

	m.Run("0.0.0.0", 6061)
}
