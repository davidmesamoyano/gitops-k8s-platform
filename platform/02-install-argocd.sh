#!/usr/bin/env bash
# Instala Argo CD y muestra la contraseña inicial del usuario admin.
set -euo pipefail
kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl -n argocd rollout status deploy/argocd-server --timeout=300s
echo
echo "Usuario: admin"
echo -n "Contraseña: "
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d; echo
echo "Abre la interfaz con:  kubectl -n argocd port-forward svc/argocd-server 8080:443 --address 0.0.0.0"
echo "y entra desde Windows en https://192.168.1.146:8080 (acepta el aviso del certificado)"
