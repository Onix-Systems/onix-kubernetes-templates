# CI\CD

# gitlab-ci.yml

```
stages:
  - package
  - deploy
```
Определить стейджи нашего проекта, допустим нам нужно запаковать проект в докер-образа и развернуть его в Кубернетесе, поэтому определяем 2 стейджа

Создаем стейдж project-image-package для упаковки докер-образа:
```
project-image-package:
  tags:
    - kuber
  stage: package
  image: docker:18.09.6-dind
  script:
  - docker login -u gitlab-ci-token -p $CI_BUILD_TOKEN ${CI_REGISTRY}
  - docker build -t ${REPOSITORY_IMAGE} .
  - docker push ${REPOSITORY_IMAGE}
```
Здесь 3 основных шага это логин, билд и пуш образа в Gitlab Registry с использование переменных. Так же в этот стейдж можно добавить создание файла с переменными внутри докер образа, что позволяет нам перед билдом образа зашить файл с переменными в сам образ и использовать его при запуске. Более детально описано в разделе [Переменные создание и использование](VARIABLES.MD)


Стейдж деплоя проекта в Кубернетес
```
project-deploy:
  tags:
  - kuber
  stage: deploy
  image: roffe/kubectl:v1.13.2
  script:
  - kubectl config set-cluster test-cluster --server=$(kubectl describe services | grep IP | sed -E 's/IP:[[:space:]]+//' | sed -E 's/Type:[[:space:]]+//' | tr -d ClusterIP)
  - NAMESPACE_NAME=$(echo -e gitdep-$CI_PROJECT_NAMESPACE-$CI_PROJECT_NAME | tr -d _)
  - kubectl create secret -n "$NAMESPACE_NAME" docker-registry gitlab-registry --docker-server="$CI_REGISTRY" --docker-username=gitlab-ci-token --docker-password="$CI_BUILD_TOKEN" --docker-email="$GITLAB_USER_EMAIL" -o yaml --dry-run | kubectl replace -n "$NAMESPACE_NAME" --force -f -
  - CI_PROJECT_NAME=$(echo -e $CI_PROJECT_NAME | tr -d _)
  - sed -i -e "s@__NAMESPACE_NAME__@${NAMESPACE_NAME}@g" dp.yml
  - sed -i -e "s@__CI_PROJECT_NAME__@${CI_PROJECT_NAME}@g" dp.yml
  - sed -i -e "s@__REPOSITORY_IMAGE__@${REPOSITORY_IMAGE}@g" dp.yml
  - kubectl apply -f dp.yml
  ```
Основные моменты на которые следует обратить внимание это: 
```
  - sed -i -e "s@__NAMESPACE_NAME__@${NAMESPACE_NAME}@g" dp.yml
  - sed -i -e "s@__CI_PROJECT_NAME__@${CI_PROJECT_NAME}@g" dp.yml
  - sed -i -e "s@__REPOSITORY_IMAGE__@${REPOSITORY_IMAGE}@g" dp.yml
  - kubectl apply -f dp.yml
  ```
С помощью команды *sed -i -e* мы подставляем переменные в файле деплоймента *dp.yml*
Командой *kubectl apply -f dp.yml* мы применяем деплоймент в Kubernetes

Файл деплоймента *dp.yml* может иметь любое название, в примерах он называется *dp.yml*

# Dockerfile
Dockerfile – это подробный пошаговый сценарий для автоматизации сборки который отвечает за сборку образа.

Простой пример Dockerfile веб сервера с php

```
FROM ulsmith/alpine-apache-php7:latest

COPY ./web /app/public

EXPOSE 80
```
В проекте может быть 1 и больше докер-файлов, более детальную информацию как это сделать ищите в разделе [Часто задаваемые вопросы](FAQ.MD)

# dp.yml

dp.yml - Файл деплоя проекта в кубернетес состоит из трех основных частей:
* [Kind Deployment](KIND_DEPLOYMENT.MD)
* [Kind Services](KIND_SERVICES.MD)
* [Kind Ingress](KIND_INGRESS.MD)

```

```
