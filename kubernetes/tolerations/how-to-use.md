# O que são Tolerations?
As Tolerations são como o "antídoto" para os Taints. Elas permitem que um Pod seja agendado em um Node que possui um Taint específico. Em outras palavras, elas "toleram" as Taints.

Obs.: As Tolerations não fazem com que o Pod seja agendado nesses Nodes, mas permite que ele seja agendado nesses Nodes.

### Exemplo de uso:
```
    spec:
      containers:
      - image: nginx
        name: nginx
      tolerations:
      - key: key-taint
        operator: Equal
        value: "value-taint"
        effect: NoSchedule
```