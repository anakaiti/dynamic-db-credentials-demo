#!/usr/bin/env bash
# set -u &
# forward=$!
# cleanup() { kill $forward; }
# trap cleanup EXIT

sleep 1
VAULT_ADDR=http://127.0.0.1:8200
token=root
vault login $token
vault auth enable kubernetes
tokendata="$(kubectl get -n vault-infra -o json "$(kubectl -n vault-infra get secret -o name | grep vault-tokenreview-token)" | jq .data)"
echo '{
    "kubernetes_host": "https://kubernetes.default",
    "disable_iss_validation": true,
    "kubernetes_ca_cert": "'"$(echo $tokendata | jq -r '."ca.crt"' | base64 -d | awk '{printf "%s\\n", $0}')"'",
    "token_reviewer_jwt": "'"$(echo $tokendata | jq -r .token | base64 -d)"'"
}' | tee /dev/stderr |  vault write auth/kubernetes/config -

echo 'path "database/creds/app" {
    capabilities = ["read"]
}

path "kv-v2/data/app" {
    capabilities = ["read"]
}' | vault write sys/policy/app-policy policy=-

echo '{
    "bound_service_account_names": ["app"],
    "bound_service_account_namespaces": ["demo"],
    "token_policies": ["app-policy"]
}' | vault write auth/kubernetes/role/demo -

# vault auth enable oidc
vault secrets enable kv-v2
vault kv put kv-v2/app db_host=postgres-db.demo.svc.cluster.local
