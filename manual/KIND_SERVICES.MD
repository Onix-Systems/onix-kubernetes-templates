# Deployment Сервисы

Services - Служба с помощью которой происходит проброс порта с вашего контейнера на Ingress контроллер, так же с помощью Services происходит доступа между подами. Сервис обеспечивает доступ к приложению внутри сети или из интернета. Сервис общается с приложением по селектору меток *label selector*

Пример слубжы services:

```
kind: Service
apiVersion: v1
metadata:
  name: __CI_PROJECT_NAME__-service
  namespace: __NAMESPACE_NAME__
spec:
  selector:
    app: __CI_PROJECT_NAME__
  ports:
  - protocol: TCP
    port: 3000
    targetPort: 3000
```

### Детально:

```
metadata:
  name: __CI_PROJECT_NAME__-service
```
Имя службы на которое ссылается IngressController

```
  namespace: __NAMESPACE_NAME__
```
Имя пространства имен

```
    app: __CI_PROJECT_NAME__
```
Ссылка на приложение для которого будет доступен сервис

```
  ports:
  - protocol: TCP
    port: 3000
    targetPort: 3000
```
Проброс портов. 
- port: - Порт который отдает сервис Ingress Controller
- targetPort: - Порт на который сервис смотрит в Docker контейнер
