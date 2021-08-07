go-run:
	go run apps/*.go

build:
	docker build -t test-demo .

db-up:
	kubectl apply -f manifest/postgres.yml
