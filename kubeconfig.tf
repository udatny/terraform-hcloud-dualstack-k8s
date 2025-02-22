module "kubeconfig" {
  source     = "matti/resource/shell"
  depends_on = [null_resource.cluster_bootstrap]

  trigger = null_resource.cluster_bootstrap.id

  command = <<EOT
    ssh -i ${var.ssh_private_key_path} -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null \
      root@${local.kubeadm_host} 'cat /root/.kube/config'
  EOT
}

module "certificate_authority_data" {
  source     = "matti/resource/shell"
  depends_on = [null_resource.cluster_bootstrap]

  trigger = null_resource.cluster_bootstrap.id

  command = <<EOT
    ssh -i ${var.ssh_private_key_path}  -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null \
      root@${local.kubeadm_host} 'kubectl config --kubeconfig /root/.kube/config view --flatten -o jsonpath='{.clusters[0].cluster.certificate-authority-data}''
  EOT
}

module "client_certificate_data" {
  source     = "matti/resource/shell"
  depends_on = [null_resource.cluster_bootstrap]

  trigger = null_resource.cluster_bootstrap.id

  command = <<EOT
    ssh -i ${var.ssh_private_key_path}  -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null \
      root@${local.kubeadm_host} 'kubectl config --kubeconfig /root/.kube/config view --flatten -o jsonpath='{.users[0].user.client-certificate-data}''
  EOT
}

module "client_key_data" {
  source     = "matti/resource/shell"
  depends_on = [null_resource.cluster_bootstrap]

  trigger = null_resource.cluster_bootstrap.id

  command = <<EOT
    ssh -i ${var.ssh_private_key_path}  -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null \
      root@${local.kubeadm_host} 'kubectl config --kubeconfig /root/.kube/config view --flatten -o jsonpath='{.users[0].user.client-key-data}''
  EOT
}