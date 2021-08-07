# dynamic-db-credentials-demo

## Initial Setup


```sh
minikube start --insecure-registry "10.0.0.0/24"
minikube addons enable registry
docker run --rm -it --network=host alpine ash -c "apk add socat && socat TCP-LISTEN:5000,reuseaddr,fork TCP:$(minikube ip):5000"

```
## Flow

1. create simple app & postgres
2. create vault server
3. setup secret engine
4. setup VSWH
5. run app
6. force rotate
    - delete pod
    - look at postgres log