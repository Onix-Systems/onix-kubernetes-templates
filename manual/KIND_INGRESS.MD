# Kind Ingress Контроллер

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
    - score-backend.staging.onix.ua
    secretName: score.staging.onix.ua-certificate-1
  rules:
  - host: score-backend.staging.onix.ua
    http:
      paths:
      - backend:
          serviceName: __CI_PROJECT_NAME__-service
          servicePort: 3000
```

### Детально:

```
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: __CI_PROJECT_NAME__-ingress
  namespace: __NAMESPACE_NAME__
```
Имя ингресс контроллера и пространства имен

```
 annotations:
    ingress.kubernetes.io/ssl-redirect: "true"
    kubernetes.io/tls-acme: "true"
    certmanager.k8s.io/cluster-issuer: letsencrypt-prod
    kubernetes.io/ingress.class: "nginx"
```
Анотации которые нужны для регистрации SSL сертификатов и которые определяют тип ингресс контроллера

```
spec:
  tls:
  - hosts:
    - __HOST_NAME__
    secretName: __HOST_NAME__-certificate-1
  rules:
  - host: __HOST_NAME__
    http:
      paths:
      - backend:
          serviceName: __CI_PROJECT_NAME__-service
          servicePort: 3000
```
Определение DNS имени и какая служба отвечает за проброс порта
