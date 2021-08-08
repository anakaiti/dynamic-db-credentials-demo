#!/usr/bin/env bash
set -euxo pipefail
kubectl port-forward -n vault-infra svc/vault 8200
