#!/usr/bin/env bash
# Instala k3s (Kubernetes ligero) y Helm en la VM Ubuntu.
set -euo pipefail
curl -sfL https://get.k3s.io | sh -s - --write-kubeconfig-mode 644
mkdir -p ~/.kube && cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
grep -q KUBECONFIG ~/.bashrc || echo 'export KUBECONFIG=~/.kube/config' >> ~/.bashrc
export KUBECONFIG=~/.kube/config
curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
kubectl wait --for=condition=Ready node --all --timeout=180s
kubectl get nodes -o wide
