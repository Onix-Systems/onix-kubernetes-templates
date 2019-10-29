
# Web Socket

Для проброса Web Socket используем Ingress контроллер.

Пример Ingress контроллера для проброса Web Socket

```
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: app-ingress
  namespace: app-backend
  annotations:
    ingress.kubernetes.io/ssl-redirect: "true"
    kubernetes.io/tls-acme: "true"
    kubernetes.io/ingress.class: "nginx"
spec:
  tls:
  - hosts:
    - my-bakend.staging.onix.ua
    secretName: my-backend-certificate
  rules:
  - host: my-backend.staging.onix.ua
    http:
      paths:
      - path: /api/ws/
        backend:
          serviceName: my-ws-api
          servicePort: 8011
      - path: /
        backend:
          serviceName: my-ws-nginx
          servicePort: 80
```

Исходя из конфигурационного файла наши Web Socket будут доступны по адресу https://my-backend.staging.onix.ua/api/ws/ 
о чем говорит эта часть конфигурации

```
 paths:
      - path: /api/ws/
        backend:
          serviceName: my-ws-api
          servicePort: 8011
```

Основное приложение бекенда будет доступно по адресу https://my-backend.staging.onix.ua/ о чем говорит эта часть конфигурации

```
      - path: /
        backend:
          serviceName: my-ws-nginx
          servicePort: 80
```
