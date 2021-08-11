build:
	docker buildx build -t ghcr.io/anakaiti/dynamic-db-credentials-demo .
	docker push ghcr.io/anakaiti/dynamic-db-credentials-demo

minikube:
	minikube start
	kubectl apply -f manifest/namespace.yaml

db-up:
	kubectl apply -f manifest/db-dep.yaml
	kubectl apply -f manifest/db-svc.yaml

db-init:
	kubectl exec -n demo $(shell kubectl get pod -n demo | grep postgres | cut -d ' ' -f 1) -- sh -c 'echo "host all all all md5" > /var/lib/postgresql/data/pg_hba.conf'
	psql -f scripts/sql/init.sql -h localhost -p 5432 -U postgres postgres

app-0-up:
	kubectl apply -f manifest/app-dep-0.yaml
	kubectl apply -f manifest/app-svc.yaml

app-up:
	kubectl apply -f manifest/app-sa.yaml
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

fwd-app:
	tmux new-session -d -s forward-app './scripts/forward-app.sh'

fwd-vault:
	tmux new-session -d -s forward-vault './scripts/forward-vault.sh'

clean:
	tmux kill-session -t forward-postgres || true
	tmux kill-session -t forward-vault || true
	tmux kill-session -t forward-app || true
	kubectl delete -f manifest/ || true

tmux-ls:
	tmux ls

fwd-stop:
	kill $(shell pgrep tmux) || true

step1: build minikube db-up app-0-up

step2: fwd-app fwd-db tmux-ls

step3: vault-up

step4: fwd-vault tmux-ls

step5: db-init vault-config

step6: app-up

step7: fwd-stop fwd-app
