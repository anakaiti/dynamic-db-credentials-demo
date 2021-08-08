#!/bin/sh
psql -h localhost -p 5432 -U postgres -c "SELECT * FROM person;" postgres
