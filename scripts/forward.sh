#!/usr/bin/env bash
set -euxo pipefail
kubectl port-forward -n vault-infra svc/vault 8200
kubeclt port-forware -n postgres svc/postgres 5432
