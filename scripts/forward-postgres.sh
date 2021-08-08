#!/usr/bin/env bash
set -euxo pipefail
kubectl port-forward -n demo svc/postgres-db 5432
