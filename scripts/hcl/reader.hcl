# Read permission on the k/v secrets
path "/secret/*" {
    capabilities = ["read", "list"]
}
