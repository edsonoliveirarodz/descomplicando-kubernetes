Revisão: 11/04/2025
# Instalando Kubernetes on premisse

Neste tutorial, foram utilizados as seguintes configurações:

- Debian 12.10

Pré-requisitos:

- Linux
- 2 GB de RAM ou mais
- 2 CPUs ou mais
- Conexão de rede entre todos os nodes no cluster

Portas que precisam estar abertas para comunicação interna do cluster:
- 6443
- 10250-10255
- 30000-32767
- 2379-2380

### Execute os próximos passos em TODOS os nodes que serão utilizados no cluster

#### 01- Desligar memória swap (Caso esteja ativada)
```
sudo swapoff -a
```
Comentar ou excluir referência do swap no arquivo /etc/fstab:
```
sudo vim /etc/fstab
```

#### 02- Instalando pacotes necessários e configurando sudo para o usuário local
```
su -
```
```
apt update && apt -y install sudo vim
```
```
usermod -aG sudo seu_usuario
```

#### 03- Habilitando modulos de kernel
```
sudo cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF
```
Carregar modulos do kernel configurados:
```
sudo modprobe overlay
sudo modprobe br_netfilter
```

#### 04- Parametrizações do systemctl
```
sudo cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF
```
Habilitando parametrizações do systemctl:
```
sudo sysctl --system
```

#### 05- Configurando repositório do Kubernetes no apt
```
sudo apt update
sudo apt install -y apt-transport-https ca-certificates curl gpg gnupg
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.32/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
sudo chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.32/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo chmod 644 /etc/apt/sources.list.d/kubernetes.list
```

#### 06- Instalando kubelet, kubeadm e kubectl
```
sudo apt update
sudo apt install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
sudo systemctl enable --now kubelet
```

#### 07- Configurando repositórios Docker e instalando o container runtime (containerd)
```
sudo apt install -y lsb-release
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update && sudo apt install -y containerd.io
```

#### 08- Configurando containerd
```
sudo containerd config default | sudo tee /etc/containerd/config.toml
```
Ativar Cgroup no arquivo /etc/containerd/config.toml:
```
sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/g' /etc/containerd/config.toml
```
Alterando sandbox_image:
```
sudo sed -i 's/sandbox_image = "registry.k8s.io\/pause:3.8"/sandbox_image = "registry.k8s.io\/pause:3.10"/g' /etc/containerd/config.toml
```
Restartando o containerd e ativando-o para inicialização junto ao sistema:
```
sudo systemctl restart containerd
sudo systemctl enable containerd
```

### Execute os próximos passos APENAS no node escolhido para ser o control-plane

#### 01- Inicialização do cluster Kubernetes
Parametros "--pod-network-cidr" e "--apiserver-advertise-address" são opcionais:
```
sudo kubeadm init --pod-network-cidr=10.10.0.0/16 --apiserver-advertise-address=<IP_DO_CONTROL_PLANE>
```

#### 02- Configurando usuário atual para utilizar o cluster criado
```
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

#### 03- Configurando kubectl autocomplete bash and alias
```
echo "source <(kubectl completion bash)" >> ~/.bashrc
echo "alias k=kubectl" >> ~/.bashrc
echo "complete -o default -F __start_kubectl k" >> ~/.bashrc
source ~/.bashrc
```

#### 04- Adicionando nodes workers ao cluster Kubernetes criado
Nos outputs finais do comando de criação do cluster, pegue o comando fornecido "kubeadm join..." e execute-o apenas nos nodes designados como worker para compor o cluster:
```
sudo kubeadm join <IP_DO_CONTROL_PLANE>:6443 --token xxx.xxx --discovery-token-ca-cert-hash sha256:xxx
```
Para verificar se os nodes foram incluídos ao cluster, execute o comando abaixo no control-plane:
```
kubectl get nodes
```
Os nodes permanecerão com o status NoReady devido a falta de um Container Network Interface (CNI).

#### 05- Configurando Container Network Interface (CNI)
Instalação do WeaveNet como CNI do cluster criado:
```
kubectl apply -f https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s.yaml
```
Os nodes agora ficarão com o status Ready e o cluster pronto para usar.
```
kubectl get nodes
```

#### 06- Configurando o LocalPath provisioner para trabalhar com volumes locais
```
kubectl apply -f https://raw.githubusercontent.com/rancher/local-path-provisioner/v0.0.31/deploy/local-path-storage.yaml
```
Tornando o StorageClass local-path como default:
```
kubectl patch storageclass local-path -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
```

#### 07- Configurando o MetalLB para trabalhar com services do tipo Loadbalancer
Para instalar e configurar o MetalLB, acesse a página abaixo:

- https://metallb.universe.tf/installation/
- https://metallb.universe.tf/configuration/#layer-2-configuration


#### 08- Configurando o Ingress Nginx Controler
Para instalar e configurar o Ingress Nginx Controler, acesse a página abaixo:

- https://kubernetes.github.io/ingress-nginx/deploy/

```
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.12.1/deploy/static/provider/baremetal/deploy.yaml
```
