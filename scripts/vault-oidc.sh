#!/bin/sh
sleep 1
VAULT_ADDR=http://127.0.0.1:8200
token=root
vault login $token

vault policy write manager ./scripts/hcl/manager.hcl
vault policy write reader ./scripts/hcl/reader.hcl

vault auth enable oidc

vault write auth/oidc/config \
         oidc_discovery_url="https://accounts.google.com" \
         oidc_client_id="$OIDC_CLIENT_ID" \
         oidc_client_secret="$OIDC_CLIENT_SECRET" \
         default_role="reader"

vault write auth/oidc/role/reader \
      bound_audiences="$OIDC_CLIENT_ID" \
      allowed_redirect_uris="http://localhost:8200/ui/vault/auth/oidc/oidc/callback" \
      allowed_redirect_uris="http://localhost:8200/oidc/callback" \
      user_claim="sub" \
      policies="reader"

echo '{
    "bound_audiences": "'"$OIDC_CLIENT_ID"'",
    "allowed_redirect_uris": "http://localhost:8200/ui/vault/auth/oidc/oidc/callback",
    "allowed_redirect_uris": "http://localhost:8200/oidc/callback",
    "user_claim": "sub",
    "policies": "manager"
}' | vault write auth/oidc/role/manager -
