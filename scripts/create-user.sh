#!/bin/sh
curl http://localhost:3000/persons -H "Accept: application/json" -X POST --data '{"firstName": "John", "secondName": "Doe", "email": "john.doe@example.com"}'
curl http://localhost:3000/persons
