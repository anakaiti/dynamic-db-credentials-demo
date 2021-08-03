package main

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"

	"github.com/jmoiron/sqlx"
)

type PersonService struct {
	db *sqlx.DB
}

type Person struct {
	FirstName string `json:"firstName"`
	SecondName string `json:"secondName"`
	Email string `json:"email"`
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
	fmt.Println(person)
	_, err = s.db.Exec("INSERT INTO person (first_name, second_name, email) VALUES ($1, $2, $3)", person.FirstName, person.SecondName, person.Email)
	if err != nil {
		log.Println(err)
		http.Error(w, http.StatusText(400), 400)
		return
	}
	w.Write([]byte("Person Created"))
}

func NewPerson(db *sqlx.DB) *PersonService {
	return &PersonService{db: db}
}
