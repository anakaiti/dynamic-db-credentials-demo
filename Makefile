build:
	docker build -t ghcr.io/anakaiti/dynamic-db-credentials-demo .
	docker push ghcr.io/anakaiti/dynamic-db-credentials-demo

minikube:
	minikube start
	kubectl apply -f manifest/namespace.yaml

db-up:
	kubectl apply -f manifest/db-dep.yaml
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

fwd-db:
	tmux new-session -d -s forward-postgres './scripts/forward-postgres.sh'

rm-fwd-db:
	tmux kill-session -t forward-postgres

fwd-app:
	tmux new-session -d -s forward-app './scripts/forward-app.sh'

rm-fwd-app:
	tmux kill-session -t forward-app

fwd-vault:
	tmux new-session -d -s forward-vault './scripts/forward-vault.sh'

rm-fwd-vault:
	tmux kill-session -t forward-vault

clean:
	kubectl delete -f manifest/

step1: build minikube db-up app-0-up

step2: fwd-app fwd-db

step3: vault-up

step4: fwd-vault

step5: vault-config

step6: app-up
