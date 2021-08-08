# Manage k/v secrets
path "/secret/*" {
    capabilities = ["create", "read", "update", "delete", "list"]
}

path "/database/*" {
    capabilities = ["create", "read", "update", "delete", "list"]
}
