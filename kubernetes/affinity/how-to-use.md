# O que são Affinity e Antiaffinity?
Affinity e Antiaffinity são conceitos que permitem que você defina regras para o agendamento de Pods em determinados Nodes. Com eles você pode definir regras para que Pods sejam agendados em Nodes específicos, ou até mesmo para que Pods não sejam agendados em Nodes específicos.

### Affinity:
Com Affinity podemos controlar com precisão onde nossos Pods serão agendados, garantindo que workloads críticos tenham os recursos que necessitam.
```
    spec:
      containers:
      - image: nginx
        name: nginx
      affinity:
        nodeAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            nodeSelectorTerms:
            - matchExpressions:
              - key: region
                operator: In
                values:
                - "us-east-1"
```

### Antiaffinity:
O Antiaffinity é o conceito contrário ao Affinity. Com ele você pode definir regras para que Pods não sejam agendados em Nodes específicos.
```
    spec:
      containers:
      - image: nginx
        name: nginx
      affinity:
        podAntiAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
          - labelSelector:
              matchExpressions:
              - key: app
                operator: In
                values:
                - nginx
            topologyKey: "region"
```