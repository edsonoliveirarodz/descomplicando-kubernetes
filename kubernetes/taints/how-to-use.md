# O que são Taints?
Taints são "manchas" ou "marcações" aplicadas aos Nodes que os marcam para evitar que certos Pods sejam agendados neles. Essa é uma forma bastante comum de isolar workloads em um cluster Kubernetes, por exemplo em momentos de manutenção ou quando você tem Nodes com recursos especiais, como GPUs.

### <span style="color: blue;">NoSchedule</span> - Faz com que o Kubernetes não agende Pods nesse Node a menos que eles tenham uma Toleration correspondente.
```
kubectl taint nodes worker-1 key=value:NoSchedule
```
### <span style="color: blue;">PreferNoSchedule</span> - Faz com que o Kubernetes tente não agendar, mas não é uma garantia.
```
kubectl taint nodes worker-1 key=value:PreferNoSchedule
```
### <span style="color: blue;">NoExecute</span> - Faz com que os Pods existentes sejam removidos se não tiverem uma Toleration correspondente.
```
kubectl taint nodes worker-1 key=value:NoExecute
```

### Para remover uma taint de um node via kubectl (Adicione "-" na frente do comando da taint conforme os exemplos abaixo):
```
kubectl taint nodes worker-1 key=value:NoSchedule-
kubectl taint nodes worker-1 key=value:PreferNoSchedule-
kubectl taint nodes worker-1 key=value:NoExecute-
```