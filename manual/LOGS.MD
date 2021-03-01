# Логирование

Для просмотра логов воспользуйтесь утилитой kubectl:


1) [Установите kubectl](https://v1-16.docs.kubernetes.io/docs/tasks/tools/install-kubectl/#install-kubectl-on-linux)
2) В домашнем каталоге создайте каталог **.kube** и положите туда файл kube-config.
3) Чтобы получиь список **Pods** выполните команду **kubectl get po**
4) Чтобы посмотреть логи нужного вам контейнера, выполните команду **kubectl logs podname**
5) Чтобы зайти в контейнер, выполните команду **kubectl exec -it podname sh**
