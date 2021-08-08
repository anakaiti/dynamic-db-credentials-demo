#!/bin/sh
echo '{"firstName": "John", "secondName": "Doe", "email": "john.doe@example.com"}' | http localhost:3000/persons
http localhost:3000/persons
