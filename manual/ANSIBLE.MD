# С чего состоит проект (описание ролей):
---
Проект состоит из нескольких ролей, каждая из которых отвечает за установку, настройку либо деплой.

- **Gitlab** - роль установки Gitlab-ce в docker контейнере. Основная задача - развернуть чистый Gitlab сервер с использованием официального докер контейнера и произвести определенные действия с настройкой его.
- **Initial** - роль отвечающая за подготовку системы для установки пакетов и служб.
- **Dependencies** - Установка Docker, Kubernetes и необходимых дополнительных пакетов для нормальной работы системы.
- **Master** - Установка дополнительного программного обеспечения на мастер ноду такого как HAProxy и Kubectl. Действия с конфигами и внутренней сетью.
- **Worker** - подключение к кластеру воркера
- **Ingress** - Установка и настройка ingress
- **Watcher** - Установка и настройка watcher. Это приложение, которое смотрим за Gitlab и контролирует создание\удаление namespaces в Kubernetes
- **Runner** - Gitlab Runner, установка и настройка
- **Service-Acc** - Создание service аккаунтов. RBAC, здесь распределяются доступы в частности здесь мы даем возможность Runner создавать ресурсы в кластере
---






#Первый запуск и настройка
---
Запуск сценария состоит из двух разных частей, установка Gitlab и Kubernetes.

- Установка Gitlab - развертывание Gitlab docker image и настройка его:
- Установка Kubernetes - установка и настройка кластера, мастера и ноды и интеграции их с Gitlab

###Установка Gitlab:

- **1) Настройка host файла:
Первым делом нужно настроить host файл, в частности настроить часть отвечающую за установку Gitlab**

>[gitlab]
192.168.33.15 ansible_ssh_user=root ansible_python_interpreter=/usr/bin/python3


- **2) Далее подготавливаем конфигурационный файл vars.yml, здесь нас интересует:**
	
*Задаем Runner Reg Token*

>runner_reg_token: "onixtesttoken"

*URL*

>gitlab_url: "http://gitlab.top/"

*Пароль от пользователя root*

>gitlab_root_password: "rootpass"

*URL Registry*

>gitlab_registry_url: "http://reg.gitlab.top/"

*Другие настройки отвечающие за редирект и отключение web сервера:*

>gitlab_nginx_enable: "true"

>gitlab_nginx_cl_max_body_size: "250m"

>gitlab_nginx_redirect: "false"

>gitlab_nginx_redirect_port: "80"

- **3) Следующий шаг - запуск сценария на выполнение**

`$Ansible-playbook gitlab.yml`

Если всё прошло успешно, то перейдя на наш URL нам должна отобразиться главная страница gitlab

- **4) Авторизируемся под root аккаунтом и получаем Access Token, который заносим в файл  vars.yml**

>gitlab_token: "39sy_59qPECxLLsmxfa4"



###Установка Kubernetes


 - **1) Настройка host файла:**

Первым делом нужно настроить host файл, те части отвечающие за подключение к хостам Kubernetes.

*Мастер нода*
>[master]
192.168.33.20 ansible_ssh_user=root ansible_python_interpreter=/usr/bin/python3

*Воркер нода*
>[node]
192.168.33.11 ansible_ssh_user=root ansible_python_interpreter=/usr/bin/python3 


- **2) Далее подготавливаем конфигурационный файл vars.yml, здесь нам нужно:**


**Использование внешнего айпи адресса**
>external_api: false # true or false

>master_taint: true # enable single master cluster
>use_workers: false # when enabled single master cluster, worker nodes is't required

>haproxy_nodes_list:

>  - { ip: "192.168.33.20", id: "1" }

>  - { ip: "192.168.33.11", id: "2" }


*Версия Helm*
>helm_version: "2.14.1"

*Runner токен*
>runner_reg_token: "onixtesttoken"

*URL по которому находится наш GitLab*
>gitlab_url: "http://gitlab.top/"

*Полученный нами Access Token*
>gitlab_token: "39sy_59qPECxLLsmxfa4"

*DNS имя по которому будут отображаться наши проекты*
>project_dns_name: "onix.top"

Например https://gitdep-root-chat.onix.top Где:

gitdep - префикс всех проектов в Kubernetes

root - имя аккаунта владельца проекта 

chat - имя проекта

- **3) Следующий шаг - запуск сценария на выполнение**

`$ansible-playbook playbook.yml`








#Template (Описание)
---
Все шаблоны автоматически пушатся в проект после его создания (в течении 1 минуты). Для проекта CI\CD требуется минимум 3 основных файла:

- .gitlab-ci.yml - файл для создания непрерывной интеграции проекта. В нем описываются самые основные моменты CI\CD, а именно тесты, билд образа, деплой и т.д.

- Dockerfile - Докерфайл, нужен для создания образа для дальнейшего деплоя

- dp.yml - Файл деплоя проекта в кубернетес

##.gitlab-ci.yml

- dp.yml - Файл деплоя проекта в кубернетес

Описание сервисов и образов которые используем

```
image: docker:latest
services:
  - docker:dind
```

Описание этапов CI\CD. Здесь можно создать любой этам, например testing

```
stages:
  - build
  - package
  - deploy
  - ...
```

Описание переменных. В этом примере DOCKER_DRIVER и DOCKER_HOST нужны для подключения к хосту докера.

```
variables:
  DOCKER_DRIVER: overlay
  DOCKER_HOST: "tcp://localhost:2375"
  ...
```

Этап сборки и пуша образа. В каждом этапе нужно указывать тег kuber, это необходимо для того, чтобы наш этап CI\CD понимал в какому Gitlab Runner обращаться. Таких тегов может быть несколько.

```
project-image-package:
  tags:
    - kuber
  stage: package
  image: docker:dind
  script:
  - echo $CONTAINER_IMAGE
  - ...
```

Этап деплоя. Используем образ **roffe/kubectl:v1.13.2**, для подключения к Kubernetes. С помощью **kubectl config set-cluster test-cluster --server=$** подключаемся к нашему кластеру для дальнейших действий. Наш namespace runner имеет доступ для деплоя в кластере. Переменная **NAMESPACE_NAME**  определена для того, чтобы исключить создание namespace с именем имеющим символ **“_”**. Далее идет создание секрета для приватных проектов (**см. Раздел Передача imagePullSecrets**). Переменная **CI_PROJECT_NAME** здесь переопределена  для того же, что и **NAMESPACE_NAME**, основная её задача убрать символ “_”. Затем командой **sed -i -e** мы редактируем переменные, находящиеся в файле деплоя dp.yml, подставляем нужные нам значения. Команда **kubectl apply -f dp.yml** выполняет файл деплоя. Можно разбить процесс деплоя на несколько разных файлов, либо не использовать этот этап вообще.

```
Project-deploy:
  tags:
  - kuber
  stage: deploy
  image: roffe/kubectl:v1.13.2
  script:
  - kubectl config set-cluster test-cluster --server=$(kubectl describe services | grep IP | sed -E 's/IP:[[:space:]]+//' | sed -E 's/Type:[[:space:]]+//' | tr -d ClusterIP)
  - NAMESPACE_NAME=$(echo -e gitdep-$CI_PROJECT_NAMESPACE-$CI_PROJECT_NAME | tr -d _)
  - kubectl create secret -n "$NAMESPACE_NAME" docker-registry gitlab-registry --docker-server="$CI_REGISTRY" --docker-username=gitlab-ci-token --docker-password="$CI_BUILD_TOKEN" --docke$
  - CI_PROJECT_NAME=$(echo -e $CI_PROJECT_NAME | tr -d _)
  - sed -i -e "s@__NAMESPACE_NAME__@${NAMESPACE_NAME}@g" dp.yml
  - sed -i -e "s@__CI_PROJECT_NAME__@${CI_PROJECT_NAME}@g" dp.yml
  - sed -i -e "s@__REPOSITORY_IMAGE__@${REPOSITORY_IMAGE}@g" dp.yml
  - kubectl apply -f dp.yml
```

##Dockerfile

Dockerfile - Докерфайл создания образа на примере простого nodejs приложения.

```
FROM node:alpine
WORKDIR /home/node/app
COPY . .
RUN npm install
EXPOSE 8081
CMD [ "node", "index.js" ]
```

##dp.yml

За деплой и развертывание всех служб в Kubernetes отвечает файл dp.yml, его задача состоит в том, чтобы задеплоить наш ранее созданный образ приложения, настроить службы, сеть, днс.
Деплой состоит из трех основных частей:

1) Deployment -  развертывание ранее созданного образа в namespace проекта.
```
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  labels:
    run: nginx
...
```

2) Service - Создание сервиса, который будет поддерживать общение между Pods внутри Namespace.
```
kind: Service
apiVersion: v1
metadata:
  name: __CI_PROJECT_NAME__-service
  namespace: __NAMESPACE_NAME__
spec:
...
```

3) Ingress - отвечает за обмен трафиком с сервисом, благодаря Ingress мы можем обратиться к нашему приложения через DNS имя


```
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: __CI_PROJECT_NAME__-ingress
  namespace: __NAMESPACE_NAME__
  annotations:
    ingress.kubernetes.io/ssl-redirect: "true"
    kubernetes.io/tls-acme: "true"
    certmanager.k8s.io/cluster-issuer: letsencrypt-prod
    kubernetes.io/ingress.class: "nginx"
spec:
  tls:
  - hosts:
    - gitdep-test-chat.onix.top
...
```

##Схема обмена трафика в Kubernetes

![](https://miro.medium.com/max/5040/1*KIVa4hUVZxg-8Ncabo8pdg.png)






#Создание проекта Step By Step
---

##Создание проекта и автоматического CI/CD 

- Создайте проект. В названии проекта не желательно указывать какие-то символы кроме латинских букв, цифр и знаков _ и -. Через некоторое время (в районе 1 минуты) в проекте появятся *.example шаблоны. Это примеры шаблонов для автоматического CI\CD

- Склонируйте проект с шаблонами

- В склонированную директорию проекта поместите код вашего проекта

- Переименуйте файлы .gitlab-ci.yml.example, Dockerfile.example и dp.yml.example и подготовьте их под свой проект. Система не запрещает добавлять свои файлы для CI\CD, поэтому вы можете этим воспользоваться и спокойно создать свои файлы для CI\CD.

- Весь подготовленный проект запушьте в репозиторий

- Наблюдать за процессом CI\CD.

- Если сценарий CI\CD прошел успешно, вы можете достучаться до него по определенному DNS адресу




#Передача imagePullSecrets (если приватный проект)
---
Для передачи imagePullSecrets Вам нужно в файле сценария .gitlab-ci.yml добавить создание секрета командой

```
kubectl create secret -n "$NAMESPACE_NAME" docker-registry gitlab-registry --docker-server="$CI_REGISTRY" --docker-username=gitlab-ci-token --docker-password="$CI_BUILD_TOKEN" --docker-email="$GITLAB_USER_EMAIL" -o yaml --dry-run | kubectl replace -n "$NAMESPACE_NAME" --force -f -
```

После чего, в файле деплоя dp.yml включить использование этого секрета 
imagePullSecrets
```
imagePullSecrets:
   - name: gitlab-registry
```

Для публичных репозиториев этого делать не нужно




###Block Scheme

[![](http://i.piccy.info/i9/227f6a3d9a83e98a7b9e3c7eab658b92/1562652111/165920/1325570/photo_2019_07_08_18_59_28.jpg)](http://i.piccy.info/i9/227f6a3d9a83e98a7b9e3c7eab658b92/1562652111/165920/1325570/photo_2019_07_08_18_59_28.jpg)

[![](http://i.piccy.info/i9/517fe54d0ba7cca383f9c15ba4e2e171/1563196539/229769/1325570/Untitled_Diagram.jpg)](http://i.piccy.info/i9/517fe54d0ba7cca383f9c15ba4e2e171/1563196539/229769/1325570/Untitled_Diagram.jpg)
