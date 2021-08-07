go-run:
	go run apps/*.go

build:
	docker build -t localhost:5000/test-demo .
	docker push localhost:5000

db-up:
	kubectl apply -f manifest/db-sts.yml --namespace=demo
	kubectl apply -f manifest/db-svc.yml --namespace=demo

app-up:
	kubectl apply -f manifest/app-dep.yml --namespace=demo
	kubectl apply -f manifest/app-svc.yml --namespace=demo

minikube:
	minikube start
	eval $(minikube docker-env)
	kubectl apply -f manifest/namespace.yml

run: minikube build db-up app-up

update: db-up app-up
