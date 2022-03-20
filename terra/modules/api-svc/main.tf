module "aks-cluster" {
  # Import the aks-cluster module and pass respective vars through
  # If you want to change providers, make a new module and call it here instead
  # passing through whatever variables you need.
  source              = "../aks-cluster"
  vm_size             = var.vm_size
  resource_group_name = var.resource_group_name
  location            = var.location
}

resource "helm_release" "api-svc" {
  name  = "api-svc-deployment"
  chart = var.helm_chart_local_path

}

resource "null_resource" "helm_test" {
  triggers = {
    name  = helm_release.api-svc.name
    chart = var.helm_chart_local_path
  }

  depends_on = [helm_release.api-svc]

  provisioner "local-exec" {
    environment = {
      KUBECONFIG = local.kubeconfig
    }
    command = <<EOF
echo "$KUBECONFIG" > ./kubeconfig
chmod 611 ./kubeconfig
export KUBECONFIG=./kubeconfig
helm test  ${helm_release.api-svc.name}
EOF
  }
}

locals {
  kubeconfig = templatefile("${path.module}/kubeconfig.tpl", {
    # If you change providers, you'll need to update these values to match your
    # providers returned values in order to generate your kubeconfig file.
    host                   = module.aks-cluster.host
    client_certificate     = module.aks-cluster.client_certificate
    client_key             = module.aks-cluster.client_key
    cluster_ca_certificate = module.aks-cluster.cluster_ca_certificate
  })
}
