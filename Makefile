go-run:
	go run apps/*.go

build:
	docker build -t localhost:5000/test-demo .
	docker push localhost:5000

db-up:
	kubectl apply -f manifest/db-sts.yaml
	kubectl apply -f manifest/db-svc.yaml

app-up:
	kubectl apply -f manifest/app-dep.yaml
	kubectl apply -f manifest/app-svc.yaml

vault-up:
	kubectl apply -f manifest/vault-infra.yaml
	kubectl apply -f manifest/vswh.yaml

minikube:
	minikube start
	kubectl apply -f manifest/namespace.yaml

run: minikube build db-up app-up

update: db-up app-up
