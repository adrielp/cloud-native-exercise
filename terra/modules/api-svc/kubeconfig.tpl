apiVersion: v1
preferences: {}
kind: Config

clusters:
  - cluster:
      server: ${host}
      certificate-authority-data: ${cluster_ca_certificate}
    name: this
contexts:
  - context:
      cluster: this
      user: this
    name: this
current-context: this
users:
  - name: this
    user:
      client-certificate-data: ${client_certificate}
      client-key-data: ${client_key}
