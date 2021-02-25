# Кind Deployment

Кind Deployment - часть конфигурационного файла для деплоймента, отвечающий за деплоймет приложения.

Пример деплоймент конфига:
```
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  labels:
    run: nginx
  name: backend
  namespace: __NAMESPACE_NAME__
spec:
  replicas: 1
  selector:
    matchLabels:
      run: __CI_PROJECT_NAME__
      app: __CI_PROJECT_NAME__
  template:
    metadata:
      labels:
        run: __CI_PROJECT_NAME__
        app: __CI_PROJECT_NAME__
    spec:
      containers:
      - name: __CI_PROJECT_NAME__
        image: __REPOSITORY_IMAGE__
        ports:
        - containerPort: 3000
      imagePullSecrets:
      - name: gitlab-registry
```
### Детально:

```
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: backend
```
Имя деплоймента, в качестве примера можно написать имя приложения либо оставить как есть. Для удобства лучше использовать короткие имена

```
  namespace: __NAMESPACE_NAME__
```
Имя пространства имен. Здесь ничего изменять не нужно

```
spec:
  replicas: 1
  selector:
    matchLabels:
      run: __CI_PROJECT_NAME__
      app: __CI_PROJECT_NAME__
  template:
    metadata:
      labels:
        run: __CI_PROJECT_NAME__
        app: __CI_PROJECT_NAME__
```
Количество реплик и метадата проекта по которой другие службы и сервисы обращаются. Этот блок редактировать не желательно.

```
    spec:
      containers:
      - name: __CI_PROJECT_NAME__
        image: __REPOSITORY_IMAGE__
        ports:
        - containerPort: 3000
```
Имя образа и порт который пробрасывается с контейнера. В переменной **__REPOSITORY_IMAGE__** находится ссылка на docker image

```
      imagePullSecrets:
      - name: gitlab-registry
```
**imagePullSecrets** - нужен для деплоймента docker образа с приватного репозитория GitLab. Смотрите раздел [Deploy Token](manual/PULL_SECRET.MD)
