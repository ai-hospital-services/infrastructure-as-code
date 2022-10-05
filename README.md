# infrastructure-as-code

[![license](https://img.shields.io/github/license/ai-hospital-services/medicine-prescriber-prototype)](/LICENSE)

> Infrastructure as Code (IaC) for AI-HOSPITAL.SERVICES

Table of Contents
- [infrastructure-as-code](#infrastructure-as-code)
	- [Repository map](#repository-map)
	- [Built With](#built-with)
	- [Getting Started](#getting-started)
		- [Prerequisites](#prerequisites)
		- [Setup backend infrastructure](#setup-backend-infrastructure)
		- [Setup kube config context](#setup-kube-config-context)
		- [Setup mongodb database](#setup-mongodb-database)
		- [Setup mysql database](#setup-mysql-database)
		- [Setup wordpress](#setup-wordpress)
	- [Authors](#authors)
	- [📝 License](#-license)


## Repository map
```text
 📌 ------------------------------> you are here
┬
├── ai-hospital.services   -------> domain website
│   ├── archive/terraform   ------> contains Terraform code for running workloads in Azure Kubernetes Services (AKS)
│   └── helm/wordpress   ---------> contains Helm charts for Kubernetetes workloads - wordpress and mysql
│── backend   --------------------> code for infrastructure and related workload deployment for backend application
│   └── terraform   --------------> contains Terraform code for running application workloads in Google Kubernetes Engine (GKE)
│   └── helm/mongodb   -----------> contains Helm charts for Kubernetes workload - mongodb used by backend api
│── media   ----------------------> contains images
```


## Built With

- Terraform v1.3
- Kubernetes & Helm chart


## Getting Started
To get a local copy up and running, follow these simple example steps.

### Prerequisites
- Install terraform: https://learn.hashicorp.com/tutorials/terraform/install-cli
- Install helm: https://helm.sh/docs/intro/install/
- Install gcloud cli: https://cloud.google.com/sdk/docs/install

### Setup backend infrastructure
```sh
# change directory
cd backend/terraform

# copy the values.tfvars to values-secret.tfvars
cp values.tfvars values-secret.tfvars

# update the 'values-secret.tfvars' file like the following, where,
# - 'project_id' is the google cloud project id
# - 'region' is the google cloud region code for e.g. asia-southeast1
# - 'zone' is the google cloud zone code for e.g. asia-southeast1-b
# - 'replica_zone' is the google cloud zone code for e.g. asia-southeast1-c
# - 'prefix' is the prefix for naming resources for e.g. ai-hospital-svcs
# - 'environment' is the middle name for naming resources for e.g. prototype
# - 'ssh_ip' is the user's public ip address who can SSH to the jump host

# initialise providers and modules
terraform init

# install infrastructure
terraform apply -var-file=values-secret.tfvars

# if you want to delete all resources created by terraform
terraform destroy -var-file=values-secret.tfvars
```

### Setup kube config context
```sh
# login to gcloud
gcloud auth application-default login

# get kube config credentials for gke cluster
gcloud container clusters get-credentials <PREFIX>-<ENVIRONMENT>-gke01 --region <REGION> --project <PROJECT ID>
```

### Setup mongodb database
```sh
# change directory
cd backend/helm

# prepare the 'mongodb/values-secret.yaml'
touch mongodb/values-secret.yaml

# update the 'mongodb/values-secret.tfvars' file like the following, where,
# mongodb:
#   rootUsername: "<MONGODB ROOT USERNAME>"
#   rootPassword: "<MONGODB ROOT PASSWORD>"
#   appUsername: "<MONGODB APP USERNAME>"
#   appPassword: "<MONGODB ROOT PASSWORD>"
# persistentVolume:
#   diskId: "projects/<PROJECT ID>/regions/<REGION>/disks/<PREFIX>-<ENVIRONMENT>-mongodbdisk01"

# to override arm64 node selection and tolerations, add,
# nodeSelector: {}
# tolerations: []

# create namespace
kubectl create namespace mongodb

# install/upgrade helm chart
helm upgrade -i mongodb mongodb -n mongodb -f mongodb/values-secret.yaml

# if you want to stop and remove helm chart and namespace
helm delete -n mongodb mongodb
kubectl delete namespace mongodb
```

### Setup mysql database
```sh
# change directory
cd ai-hospital-services/helm

# prepare the 'mysql/values-secret.yaml'
touch wordpress/values-secret.yaml

# update the 'mysql/values-secret.tfvars' file like the following, where,
# mysql:
#   rootPassword: "<MYSQL ROOT PASSWORD>"
#   wordpressUsername: "<MYSQL WORDPRESS USERNAME>"
#   wordpressPassword: "<MYSQL WORDPRESS PASSWORD>"
# persistentVolume:
#   diskId: "projects/<PROJECT ID>/regions/<REGION>/disks/<PREFIX>-<ENVIRONMENT>-mysqldisk01"

# to override arm64 node selection and tolerations, add,
# nodeSelector: {}
# tolerations: []

# create namespace
kubectl create namespace mysql

# install/upgrade helm chart
helm upgrade -i mysql mysql -n mysql -f mysql/values-secret.yaml

# if you want to stop and remove helm chart and namespace
helm delete -n mysql mysql
kubectl delete namespace mysql
```

### Setup wordpress
```sh
# change directory
cd ai-hospital-services/helm

# prepare the 'wordpress/values-secret.yaml'
touch wordpress/values-secret.yaml

# update the 'wordpress/values-secret.tfvars' file like the following, where,
# wordpress:
#   mysqlUsername: "<MYSQL WORDPRESS USERNAME>"
#   mysqlPassword: "<MYSQL WORDPRESS PASSWORD>"
# persistentVolume:
#   diskId: "projects/<PROJECT ID>/regions/<REGION>/disks/<PREFIX>-<ENVIRONMENT>-wordpressdisk01"
# letsencrypt:
#   enabled: true
#   email: "<DOMAIN EMAIL ADDRESS>"
#   mode: "production"

# to override arm64 node selection and tolerations, add,
# nodeSelector: {}
# tolerations: []

# create namespace
kubectl create namespace wordpress

# install/upgrade helm chart
helm upgrade -i wordpress wordpress -n wordpress -f wordpress/values-secret.yaml

# if you want to stop and remove helm chart and namespace
helm delete -n wordpress wordpress
kubectl delete namespace wordpress
```


## Authors

👤 **Ankur Soni**

- [![Github](https://img.shields.io/github/followers/ankursoni?style=social)](https://github.com/ankursoni)
- [![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://linkedin.com/in/ankursoniji)
- [![Twitter](https://img.shields.io/twitter/url/https/twitter.com/fold_left.svg?style=social&label=Follow%20%40ankursoniji)](https://twitter.com/ankursoniji)


## 📝 License

This project is [Apache](./LICENSE) licensed.
