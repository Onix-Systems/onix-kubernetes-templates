# Миграция worker node

### 1. Подготовить новый worker node
В качестве ОС используем чистую **Ubuntu 18.04**.
Для Worker node требуется минимум 32Gb RAM

Далее нужно запустить Ansible Worker Role которая установить всё необходимые пакеты и подготовит worker node.
Worker node должна использовать тот же плагин сети что и мастер (в нашем случаи это **Flannel**)

### 2. Подключение worker node.
Для начала нужно получить токен. На master node выполняем следующую команду:
```
kubeadm token create --print-join-command
```

После чего нужно выполнить пример команды на worker node

```
kubeadm join 192.168.122.195:6443 --token nx1jjq.u42y27ip3bhmj8vj --discovery-token-ca-cert-hash sha256:c6de85f6c862c0d58cc3d10fd199064ff25c4021b6e88475822d6163a25b4a6c
```

### 3. Что бы удалить старый воркер нужно выполнить команды:
```
Kubectl get no
kubectl drain <node-name>
kubectl delete node <node-name>
```
После чего старая worker node будет удалена
