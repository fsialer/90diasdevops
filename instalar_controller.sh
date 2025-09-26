# Añadir repo de Helm
helm repo add actions-runner-controller https://actions-runner-controller.github.io/actions-runner-controller

# Instalar ARC Controller
helm install arc \
    --namespace arc-systems \
    --create-namespace \
    oci://ghcr.io/actions/actions-runner-controller-charts/gha-runner-scale-set-controller

# Verificar instalación
kubectl get pods -n arc-systems