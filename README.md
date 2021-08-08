# dynamic-db-credentials-demo

## Expected Case
1. Application will ask the vault for its username & password everytime it deployed
2. Administration user will be able to ask for user & password for administration database access
3. Non administration user will be able to ask for user & password for read-only database access

## Dependencies
1. docker
2. access to ghrc.io
3. minikube
4. kubectl
5. vault-cli
7. psql
8. curl
9. tmux

## Flow

1. create simple app & postgres
```
make step1
```
2. test some application access
```
make step2
```
3. deploy vault server
```
make step3
```
4. set vault port forward
```
make step4
```
4. setup vault config
```
make step5
```
5. setup secret engine
```
make step6
```
