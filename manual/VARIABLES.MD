# Создание и использование переменных

Для процесса CI/CD используются два типа переменных:

* [Переменные деплоймента](VARIABLES.MD#переменные-деплоймента)
* [Переменные проекта](VARIABLES.MD#переменные-проекта)


## Переменные деплоймента
Переменные деплоймента - это те переменные, которые нужны для процесса CI/CD и выглядят они так: `__MY_ENV__`
В основном используются такие переменные:

- `__NAMESPACE_NAME__` - Имя пространста имен, генерируется автоматически
- `__CI_PROJECT_NAME__` - Имя проекта, генерируется автоматически, но при желании можно изменить на свое, но нужно учитывать то, что могут быть конфликты, по тому лучше оставить как есть
- `__REPOSITORY_IMAGE__` - Имя образа докер образа.

Эти переменные встречаются в основном в файлах *gitlab-ci.yml* и *dp.yml*. В файле *gitlab-ci.yml* встретить их можно в самом конце файла
```
  - sed -i -e "s@__NAMESPACE_NAME__@${NAMESPACE_NAME}@g" dp.yml
  - sed -i -e "s@__CI_PROJECT_NAME__@${CI_PROJECT_NAME}@g" dp.yml
  - sed -i -e "s@__REPOSITORY_IMAGE__@${REPOSITORY_IMAGE}@g" dp.yml
  - kubectl apply -f dp.yml
```
С помощью команды *sed -i -e* мы, перед тем как запустить на выполение файл деплоя *kubectl apply -f dp.yml* заменяем значение этих переменных на нужное нам.

В файле *dp.yml* можно наблюдать то где эти переменные используются, например:

```
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  labels:
    run: nginx
  name: __CI_PROJECT_NAME__-deployment
  namespace: __NAMESPACE_NAME__
spec:
  replicas: 1
  selector:
    matchLabels:
      run: __CI_PROJECT_NAME__
      app: __CI_PROJECT_NAME__
...
```
Здесь видно как мы с помощью переменных подставляем *namespace* и задаем *selector* с помощью переменной `__CI_PROJECT_NAME__`. Можно объявить свои переменные  (при необходимости).

## Переменные проекта
#### Создание
С помощью переменных вы можете передавать какие-то уникальные секретные данные такие как пароли, логины, токены и т.д.

Создание переменных:

Для создания переменных, Вам нужно зайти:

- Settings → CI/CD → Variables

![](http://i.piccy.info/i9/8288006e59ac1bbd6578992059ff9551/1570102250/99038/1333933/variables.png)

#### Использование

Использовать переменные можна в файле для создания непрерывной интеграции проекта *.gitlab-ci.yml*

![](http://i.piccy.info/i9/c99bd746508325c216cf6aaf47a965fe/1570102688/62377/1333933/Snymok_ekrana_ot_2019_10_03_14_35_53.png)

Здесь мы заполняем файл с переменными для работы приложения


## Переменные Dockerfile

В случаи если вам нужно объявить переменные в Dockerfile, можно использовать --build-arg во время билда докер образа, что бы передать переменные контейнеру во время билда

```
ARG RAILS_MASTER_KEY
ARG MAIL_PASSWORD
ARG MAIL_USERNAME
ARG POSTGRES_DB
ARG POSTGRES_HOST
ARG POSTGRES_PASS
ARG POSTGRES_USER
ARG RAILS_LOG_TO_STDOUT
ARG RAILS_SERVE_STATIC_FILES
ARG RAILS_ENV
ARG SECRET_KEY_BASE

ENV RAILS_ENV $RAILS_ENV
ENV RACK_ENV $RAILS_ENV
ENV SECRET_KEY_BASE $SECRET_KEY_BASE
ENV RAILS_MASTER_KEY $RAILS_MASTER_KEY
ENV MAIL_PASSWORD $MAIL_PASSWORD
ENV MAIL_USERNAME $MAIL_USERNAME
ENV POSTGRES_DB $POSTGRES_DB
ENV POSTGRES_HOST $POSTGRES_HOST
ENV POSTGRES_PASS $POSTGRES_PASS
ENV POSTGRES_USER $POSTGRES_USER
ENV RAILS_LOG_TO_STDOUT $RAILS_LOG_TO_STDOUT
ENV RAILS_SERVE_STATIC_FILES $RAILS_SERVE_STATIC_FILES
```

.gitlab-ci.yml

```
docker build --build-arg POSTGRES_DB=$POSTGRES_DB --network=host -t ${REPOSITORY_IMAGE} .
```

Где:

$POSTGRES_DB переменная объявленная в  Settings → CI/CD → Variables

POSTGRES_DB= - аргумент в Dockerfile ARG POSTGRES_HOST
