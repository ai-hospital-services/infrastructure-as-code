# create secret vars file
```shell
cp wordpress/values.yaml wordpress/values-secret.yaml
```

# helm lint
```shell
helm lint mysql -f mysql/values-secret.yaml

helm lint wordpress -f wordpress/values-secret.yaml

helm lint mailu-prerequisite -f mailu-prerequisite/values-secret.yaml
```

# helm debug
```shell
helm install mysql mysql --debug --dry-run -f mysql/values-secret.yaml
helm template mysql mysql --debug --dry-run -f mysql/values-secret.yaml

helm install wordpress wordpress --debug --dry-run -f wordpress/values-secret.yaml
helm template wordpress wordpress --debug --dry-run -f wordpress/values-secret.yaml

helm install mailu-prerequisite mailu-prerequisite  --debug --dry-run -f mailu-prerequisite/values-secret.yaml
helm template mailu-prerequisite mailu-prerequisite  --debug --dry-run -f mailu-prerequisite/values-secret.yaml
```

# helm install
```shell
helm install cert-manager cert-manager \
    --repo "https://charts.jetstack.io" \
    --namespace cert-manager \
    --create-namespace \
    --version v1.7.2 \
    --set installCRDs=true

helm install mysql mysql -f mysql/values-secret.yaml

helm install wordpress wordpress -f wordpress/values-secret.yaml

helm install mailu-prerequisite mailu-prerequisite -f mailu-prerequisite/values-secret.yaml

helm install mailu mailu \
    --repo "https://mailu.github.io/helm-charts" \
    --namespace mailu \
    --values mailu-values-secret.yaml \
    --version 0.3.1

helm install ingress-nginx ingress-nginx \
    --repo https://kubernetes.github.io/ingress-nginx \
    --namespace ingress-nginx \
    --create-namespace \
    --version 4.0.18
```

# helm upgrade
```shell
helm upgrade mysql mysql -f mysql/values-secret.yaml
helm upgrade wordpress wordpress -f wordpress/values-secret.yaml
helm upgrade mailu-prerequisite mailu-prerequisite -f mailu-prerequisite/values-secret.yaml
```

# helm uninstall
```shell
helm uninstall ingress-nginx -n ingress-nginx
helm uninstall mailu -n mailu
helm uninstall mailu-prerequisite
helm uninstall wordpress
helm uninstall mysql
helm uninstall cert-manager -n cert-manager
```

# port forward
```shell
kubectl port-forward svc/wordpress-internal-svc -n wordpress 8080:80
```

# backup
```shell
helm install velero velero \
    --repo https://vmware-tanzu.github.io/helm-charts \
    --namespace velero \
    --create-namespace \
    --
```