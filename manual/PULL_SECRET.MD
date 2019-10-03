# Передача imagePullSecrets (если приватный проект)

Для передачи imagePullSecrets нужно создать Deploy Token.

- Идем в  Settings → Repository  → Deploy Tokens и создаем новый Deploy Token
- Далее идем в  Settings → CI/CD → Variables и создаем 2 новые переменные

![](http://i.piccy.info/i9/5e218844d22a68d5ae818051d881c01c/1566392227/23625/1333933/Snymok_ekrana_ot_2019_08_21_15_56_11.png)
Где
```
--docker-username="$REGISTRY_DEPLOY_LOGIN"
--docker-password="$REGISTRY_DEPLOY_TOKEN"
```
- Передача токена в файле dp.yml выглядит так

```
- kubectl create secret -n "$NAMESPACE_NAME" docker-registry gitlab-registry --docker-server="$CI_REGISTRY" --docker-username="$REGISTRY_DEPLOY_LOGIN" --docker-password="$REGISTRY_DEPLOY_TOKEN" --docker-email="$GITLAB_USER_EMAIL" -o yaml --dry-run | kubectl replace -n "$NAMESPACE_NAME" --force -f -
```

