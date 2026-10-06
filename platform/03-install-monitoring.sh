#!/usr/bin/env bash
# Instala Prometheus + Grafana (kube-prometheus-stack) y el dashboard de la app.
set -euo pipefail
cd "$(dirname "$0")"
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm upgrade --install monitoring prometheus-community/kube-prometheus-stack \
  --namespace monitoring --create-namespace \
  -f monitoring-values.yaml --wait --timeout 10m
kubectl apply -f grafana-dashboard.yaml
echo "Grafana: kubectl -n monitoring port-forward svc/monitoring-grafana 3000:80 --address 0.0.0.0"
echo "y entra desde Windows en http://192.168.1.146:3000  (admin / la contraseña de monitoring-values.yaml)"
