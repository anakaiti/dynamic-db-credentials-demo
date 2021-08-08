#!/bin/sh
sleep 1
VAULT_ADDR=http://127.0.0.1:8200
token=root
vault login $token

vault policy write manager ./scripts/hcl/manager.hcl
vault policy write reader ./scripts/hcl/reader.hcl

vault auth enable oidc

vault write auth/oidc/config \
         oidc_discovery_url="https://accounts.google.com/o/oauth2/auth" \
         oidc_client_id="485232767497-8630mqp95jli1tvqnmffbcfqaukjnple.apps.googleusercontent.com" \
         oidc_client_secret="wvu774ymNYBPm2ui6P9ggjCm" \
         default_role="reader"
