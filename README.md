# Cloud Native Exercise

## Exercise Goal
The goal of this exercise is:
- Create a REST API microservice deployable into kubernetes
- Provision the kubernetes cluster via automation, ensuring it's defined as code
- Automatically deploy the microservice into the kubernetes cluster during the provisioning
- Ensure automated tests exist to validate the environment
- Do it all via one command

## Tool Architecture Based on the goal of this exercise, the following tools are my recommended choice for deploying
the application.
- Python [FAST API](https://fastapi.tiangolo.com) deployed as a container
- [Terraform](https://www.terraform.io) the provisioner
- [Terragrunt](https://terragrunt.gruntwork.io) a wrapper to terraform to keep code dry
- [Helm](https://helm.sh) to deploy the chart in kubernetes
- A cloud provider, I've chosen [Azure](https://azure.microsoft.com/en-us/)
- [Docker](https://www.docker.com) to build the container image
- [Helm Docs](https://github.com/norwoodj/helm-docs) to generated the README.md for the helm chart

## Directory Structure
The below is the stucture of this project. For all intents and purposes, this
repository can be considered a monorepo. Monorepos have advantages and disadvantages,
but for a small exercise like this, a monorepo makes the most sense.

In production, I would gravitate towards having multiple repositories like below:
- terraform-modules # hosts custom terraform modules
- infra-config # hosts the config files necessary for deployment via terragrunt
- python-api # hosts the files necessary to build the api server and the app chart

Each of these repositories would be independently semantically versioned.

## Python Fast API Restful microservice
The Python FastAPI microservice is a simple app that has a couple end points.
See the [api-svc README.md](./api-svc/README.md) to learn more.

## Helm chart
The `api-svc` helm chart is located in [./api-svc/chart/api-svc](./api-svc/chart/api-svc).

This can be deployed to a local kubernetes cluster with minimal effort. It presumes you have
a docker or minikube (etc) kubernetes cluster installed locally, with the nginx ingress chart
installed from [kubernetes.github.io](https://kubernetes.github.io/ingress-nginx)

The command below is taken directly from their quick start guide.
```
helm upgrade --install ingress-nginx ingress-nginx \
  --repo https://kubernetes.github.io/ingress-nginx \
  --namespace ingress-nginx --create-namespace
```

Then, presumming the image has already been built either locally via [./build.sh](./api-svc/build.sh)
or it exists in the public hub.docker.com registry, you can run something similar to the following
to deploy and test locally in your Kubernetes cluster.
> also presumes you have edited your /etc/hosts file locally to point 127.0.0.1 to api-svc.local
```
cd api-svc/chart/api-svc
helm upgrade -i api-svc . --wait \
    && helm test api-svc
```

For the full set of values you can provide to the very simple helm chart, please
read the [README.md](./api-svc/chart/api-svc/README.md)

## Terragrunt Configuration
The [terra](./terra) directory contains configuration files to run Terragrunt
against. See the [README.md](./terra/README.md) for more information.

## Dreaming of ToDos
There are several things I'd like to add to this functionality, and would certainly
add in a production setting. The below is partial list :)
1. Add a github action to call semantic-release and automatically version this monorepo
2. Publish said version of the container image matching the semantic versioning of the repository.
3. Add public DNS to the AKS cluster
4. Update the values files in the helm deployment during provisioning to allow the ingress
to route the traffic publicly.
5. Enable TLS on the ingress router.
6. Further cleanup and parameterize the terragrunt deployment.
7. Build out a test suite using terratest for the modules and deployment.
8. Add a github action that runs terratests upon PR build
9. Add SOPS encryption to the terragrunt files for the provider secrets instead of using azure CLI secret exporting
10. Secure all the things :) (mmm mTLS via a service mesh sounds good)

## Really Helpful Resources that I leveraged/looked into (even for todos)
- [Microsoft docs](https://docs.microsoft.com/en-us/azure/developer/terraform/create-k8s-cluster-with-aks-applicationgateway-ingress#9-install-helm)
- [Terraform docs (azurerm)](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster#effective_outbound_ips)
- [Terraform docs (helm)](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release)
- [Terraform docs (azurerm service principle for automation)](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/service_principal_client_certificate)
- [Github actions](https://github.com/marketplace?type=actions)
- [Terratest examples (While I was researching)](https://terratest.gruntwork.io/examples/)
- [Terragrunt docs](https://terragrunt.gruntwork.io/docs/reference/built-in-functions/#get_repo_root)
- [Block post about helm test after realizing the provider didn't have that functionality](https://jwenz723.medium.com/using-terraform-to-deploy-a-helm-chart-with-helm-test-execution-e2c4a5d12bbe)
- [FastAPI docs](https://fastapi.tiangolo.com)
