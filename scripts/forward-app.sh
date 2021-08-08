#!/usr/bin/env bash
set -euxo pipefail
kubectl port-forward -n demo svc/demo-app 3000
