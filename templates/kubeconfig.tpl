apiVersion: v1
preferences: {}
kind: Config

clusters:
- cluster:
    server: https://${endpoint}:6443
    certificate-authority-data: ${cluster_auth_base64}
  name: ${kubeconfig_name}

contexts:
- context:
    cluster: ${kubeconfig_name}
    user: ${kubeconfig_name}
  name: ${kubeconfig_name}

current-context: ${kubeconfig_name}

users:
- name: ${kubeconfig_name}
  user:
    client-certificate-data: ${client-certificate-data}
    client-key-data: ${client-key-data}