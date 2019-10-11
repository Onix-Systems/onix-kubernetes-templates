# Регистрация сертификатов

За регистрацию https сертификатов отвечает [ингресс контроллер](KIND_INGRESS.MD).

По стандартному включен сертификат типа staging

```
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: __CI_PROJECT_NAME__-ingress
  namespace: __NAMESPACE_NAME__
  annotations:
    ingress.kubernetes.io/ssl-redirect: "true"
    kubernetes.io/tls-acme: "true"
    certmanager.k8s.io/cluster-issuer: letsencrypt-staging
    kubernetes.io/ingress.class: "nginx"
    ...
```
Это не валидный сертификат, который вполне подходит для тестов.

Для регистрации валидного сертификата нужно изменить анотацию *letsencrypt-staging* на *letsencrypt-prod*

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
    ...
```

После чего, через некоторое время у вас появится валидный сертификат
