### Before install
Make sure you have installed wget


### Install
#### Step 1
``` 
    wget https://raw.githubusercontent.com/Onix-Systems/onix-kubernetes-templates/master/deploy/nodejs/kubernetes-deploy.sh
```

#### Step 2 
``` 
    bash ./kubernetes-deploy.sh
```

#### Step 3 
Choose your databases, if your template will not be found then we don't support him at the current moment. You need to ask for it an admin

#### Step 4 
The script will ask for your login & password for gitlab login to make git pull & git push to your repository.

#### Step 5 
After successfull git push to your repository go to your gitlab repository and go CI/CD.

#### Step 6 
Fill there all your variables for the project in key - value format.

#### Step 7
Open your .gitlab-ci.yml and edit variables using the example.

#### Step 8 
Check your deploy in CI/CD pipeline tab where you can check each step there, if you click by a step you can check all his logs(so you can debug different fails)

#### Step 9 
If the deploying was successfully then go https://onix-systems-<project-name>-kubernetes.staging.onix.ua/<default-route>

#### Enjoy!

##### Warnings
Your repository shouldn't have already .gitlab-ci.yml or other files what are using for deploy on kubernetes.

##### Notices 
If you want to write the same script but for another language then write templates for app container & will need to re-write some kubernetes-deploy.sh
