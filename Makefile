build:
	docker build -t ghcr.io/anakaiti/dynamic-db-credentials-demo .
	docker push ghcr.io/anakaiti/dynamic-db-credentials-demo

minikube:
	minikube start
	kubectl apply -f manifest/namespace.yaml

db-up:
	kubectl apply -f manifest/db-sts.yaml
	kubectl apply -f manifest/db-svc.yaml

app-0-up:
	kubectl apply -f manifest/app-dep-0.yaml
	kubectl apply -f manifest/app-svc.yaml

app-up:
	kubectl apply -f manifest/app-dep.yaml
	kubectl apply -f manifest/app-svc.yaml

vault-up:
	kubectl apply -f manifest/vault-infra.yaml
	kubectl apply -f manifest/vswh.yaml

vault-config:
	./scripts/vault-db.sh
	./scripts/vault-kube.sh
	./scripts/vault-oidc.sh

clean:
	kubectl delete -f manifest/

step1: build minikube db-up app-0-up

step2: vault-up

step3: vault-config

step4: app-up
