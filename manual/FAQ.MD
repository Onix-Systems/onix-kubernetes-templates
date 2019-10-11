## Мне нужен сервер базы данных, где его взять и как подключиться ?
- Мы предоставляем наши сервера БД, плюсы в том что вам нет необходимости разварачивать свой сервер БД.
Более детально в разделе [База данных](DATABASE.MD)

## Мне нужно создать ещё одну БД, что делать ?
- Более подробно в разделе - [Нужно создать ещё одну базу данных](DATABASE.MD#нужно-создать-ещё-одну-базу-данных)

## Как добавить два образа в процесс ci\cd ?
- Для добавления ещё одного образа в проект, воспользуйтесь переменными, нужно создать дополнительную переменную для образа, 
например:

```
...

variables:
  DOCKER_DRIVER: overlay
  DOCKER_HOST: "tcp://localhost:2375"
  REPOSITORY_IMAGE: "${CI_REGISTRY}/${CI_PROJECT_PATH}:${CI_PIPELINE_IID}"
  REPOSITORY_IMAGE_NGINX: "${CI_REGISTRY}/${CI_PROJECT_PATH}:nginx-${CI_PIPELINE_IID}"
  REPOSITORY_IMAGE_EX_NGINX: "${CI_REGISTRY}/${CI_PROJECT_PATH}:exnginx-${CI_PIPELINE_IID}"
...
```
Где *REPOSITORY_IMAGE_NGINX* и *REPOSITORY_IMAGE_EX_NGINX* дополнительные образы с тегами *nginx-latest* и *exnginx-latest*

Подставить их в файл деплоймента можно с помощью переменных деплоймента 

```
  - sed -i -e "s@__REPOSITORY_IMAGE__@${REPOSITORY_IMAGE_EX_NGINX}@g" dp-back-nginx-ex.yml
  - kubectl apply -f dp-back-nginx-ex.yml
```
Где с переменной REPOSITORY_IMAGE_EX_NGINX мы подставляем значение в [переменную для деплоя](VARIABLES.MD#переменные-деплоймента) *__REPOSITORY_IMAGE__*



## Зачем использовать тег kuber ?

## Как сделать ci\cd с одной ветки и как запретить сборку с другой ветки?

## Как мне игнорировать сборку некоторых бранчей ?

## Зачем нужны переменные 
