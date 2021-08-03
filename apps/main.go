package main

import (
	"fmt"
	"log"
	"net/http"

    _ "github.com/lib/pq"
	"github.com/go-chi/chi"
	"github.com/go-chi/chi/middleware"
	"github.com/jmoiron/sqlx"
)

func main() {
	dbString := GetEnv("DB_CONN", "host=localhost port=5432 user=postgres dbname=postgres password=postgres sslmode=disable")
	fmt.Println(dbString)
	db, err := sqlx.Connect("postgres", dbString)
	if err != nil {
		log.Fatalln(err)
	}
	RunMigrate(db)
	r := chi.NewRouter()
	r.Use(middleware.Logger)
	r.Get("/", func(w http.ResponseWriter, r *http.Request) {
		w.Write([]byte("hello world"))
	})
	http.ListenAndServe(":3000", r)
}
