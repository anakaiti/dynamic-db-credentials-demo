# Read permission on the k/v secrets
path "/secret/*" {
    capabilities = ["read", "list"]
}

path "/database/creds/viewer" {
    capabilities = ["create", "read", "update", "delete", "list"]
}
