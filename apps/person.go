package main

import (
	"encoding/json"
	"io/ioutil"
	"log"
	"net/http"

	"github.com/jmoiron/sqlx"
)

type PersonService struct {
	db *sqlx.DB
}

type Person struct {
	FirstName string `json:"firstName" db:"first_name"`
	SecondName string `json:"secondName" db:"second_name"`
	Email string `json:"email" db:"email"`
}

func (s *PersonService) createPerson(w http.ResponseWriter, r *http.Request) {
	body, err := ioutil.ReadAll(r.Body)
	if err != nil {
		log.Println(err)
		http.Error(w, http.StatusText(400), 400)
		return
	}
	var person Person
	err = json.Unmarshal(body, &person)
	if err != nil {
		log.Println(err)
		http.Error(w, http.StatusText(400), 400)
		return
	}
	_, err = s.db.Exec("INSERT INTO person (first_name, second_name, email) VALUES ($1, $2, $3)", person.FirstName, person.SecondName, person.Email)
	if err != nil {
		log.Println(err)
		http.Error(w, http.StatusText(400), 400)
		return
	}
	w.Write([]byte("Person Created"))
}

func (s *PersonService) getAllPerson(w http.ResponseWriter, r *http.Request) {
	people := []Person{}
	err := s.db.Select(&people, "SELECT * FROM person ORDER BY first_name ASC")
	if err != nil {
		log.Println(err)
		http.Error(w, http.StatusText(500), 500)
		return
	}
	json.NewEncoder(w).Encode(people)
}

func NewPerson(db *sqlx.DB) *PersonService {
	return &PersonService{db: db}
}
