# create secret vars file
```shell
cp values.yaml values-secret.yaml
```

# helm install
```shell
helm install cert-manager cert-manager \
    --repo "https://charts.jetstack.io" \
    --namespace cert-manager \
    --create-namespace \
    --version v1.6.1 \
    --set installCRDs=true

helm install wordpress . -f values-secret.yaml

helm install ingress-nginx ingress-nginx \
    --repo https://kubernetes.github.io/ingress-nginx \
    --namespace wordpress \
    --version 4.0.16
```

# helm upgrade
```shell
helm upgrade wordpress . -f values-secret.yaml
```

# helm uninstall
```shell
helm uninstall nginx-ingress -n wordpress
helm uninstall wordpress
helm uninstall cert-manager -n cert-manager
```

# port forward
```shell
kubectl port-forward svc/wordpress-internal-svc -n wordpress 8080:80
```