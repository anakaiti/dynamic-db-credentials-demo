package main

import (
	"fmt"
	"log"
	"net/http"

	"github.com/go-chi/chi/v5"
	"github.com/go-chi/chi/v5/middleware"
	"github.com/jmoiron/sqlx"
	_ "github.com/lib/pq"
)

func main() {
	dbString := GetEnv("DB_CONN", "host=localhost port=5432 user=postgres dbname=postgres password=postgres sslmode=disable")
	db, err := sqlx.Connect("postgres", dbString)
	service := NewPerson(db)
	if err != nil {
		log.Fatalln(err)
	}
	RunMigrate(db)
	r := chi.NewRouter()
	r.Use(middleware.Logger)
	r.Route("/persons", func (r chi.Router) {
		r.Post("/", service.createPerson)
		r.Get("/", service.getAllPerson)
	})
	http.ListenAndServe(fmt.Sprintf(":%s", GetEnv("PORT", "3000")), r)
}
