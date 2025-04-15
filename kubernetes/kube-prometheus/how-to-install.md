# How to install - Kube Prometheus
### Repositório:
```
git clone https://github.com/prometheus-operator/kube-prometheus.git
```

### Setting up the initial environment:
```
kubectl create -f manifests/setup
```

### Applying the manifests:
```
kubectl apply -f manifests
```