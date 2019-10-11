# Анализатор кода

SonarQube — платформа с открытым исходным кодом для непрерывного анализа и измерения качества кода.

Что бы включить анализатор кода в свой проект, нужно добавить stages - analysis в [.gitlab-ci.yml](CI-CD.MD#gitlab-ciyml)

```
...

stages:
  - analysis

project-analysis-code:
  stage: analysis
  image: ciricihq/gitlab-sonar-scanner:3.2.1
  variables:
    SONAR_URL: https://sonarqube.staging.onix.ua
    SONAR_ANALYSIS_MODE: publish
  only:
  - master
  script:
  - gitlab-sonar-scanner -Dsonar.login=$SONAR_LOGIN -Dsonar.gitlab.ref_name=$CI_COMMIT_REF_NAME -Dsonar.gitlab.project_id=$CI_PROJECT_ID -Dsonar.gitlab.commit_sha=$CI_COMMIT_SHA -Dsonar.gitlab.url=https://gitlab.onix.ua/
  tags:
  - kuber
```

После чего, в пайплайне появится ещё один стейдж project-analysis-code в котором будет анализироваться ваш код. 
В случаи если анализатор найдет ошибки в коде, он выдаст ошибку, поэтому мы рекомендуем запускать этот стейлж после основного
деполя приложения в Кубернетес

![Kubernetes](http://i.piccy.info/i9/2ceefeb66c8ae89aaa9916b5c18cb7e1/1570776178/9285/1333933/sonar1.png)

Более подробно информацию можно прочесть в комментариях к текущему коммиту:

![Kubernetes](http://i.piccy.info/i9/d9f045b90e66c41d4ee308c06cc055e6/1570776625/71423/1333933/sonar3.png)
