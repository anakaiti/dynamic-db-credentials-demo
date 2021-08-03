package main

import "github.com/jmoiron/sqlx"

var schema = `
	CREATE TABLE IF NOT EXISTS person (
		first_name text,
		second_name text,
		email text
	)
`

func RunMigrate(db *sqlx.DB) {
	db.MustExec(schema)
}
