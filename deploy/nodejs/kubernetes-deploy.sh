#Global Variables (Paths to templates)
#Node js Templates
MONGODB="https://gitlab.com/pavel_pavlov1/kubernetes-templates/-/raw/master/nodejs/dp-mongo.yml"
REDIS="https://gitlab.com/pavel_pavlov1/kubernetes-templates/-/raw/master/nodejs/dp-redis.yml"
APP_TEMPLATE="https://gitlab.com/pavel_pavlov1/kubernetes-templates/-/raw/master/nodejs/dp.yml"
APP_DOCKERFILE="https://gitlab.com/pavel_pavlov1/kubernetes-templates/-/raw/master/nodejs/Dockerfile"

# TEMPLATES
#MONGODB
REDIS_MONGODB_TEMPLATE="https://gitlab.com/pavel_pavlov1/kubernetes-templates/-/raw/master/nodejs/gitlab-ci-templates/mongo-redis.yml"
MONGODB_TEMPLATE="https://gitlab.com/pavel_pavlov1/kubernetes-templates/-/raw/master/nodejs/gitlab-ci-templates/mongo.yml"
MONGODB_MYSQL_TEMPLATE="https://gitlab.com/pavel_pavlov1/kubernetes-templates/-/raw/master/nodejs/gitlab-ci-templates/mongo-mysql.yml"
#MYSQL
MYSQL_REDIS_TEMPLATE="https://gitlab.com/pavel_pavlov1/kubernetes-templates/-/raw/master/nodejs/gitlab-ci-templates/mysql-redis.yml"
MYSQL_TEMPLATE="https://gitlab.com/pavel_pavlov1/kubernetes-templates/-/raw/master/nodejs/gitlab-ci-templates/mysql.yml"

read -p "Type your output branch: " gitlabBranch
read -p "Type your url to gitlab repo: " gitlabRepository

#Databases
read -p "Will you use mongodb? - " isMongodbNeeded
read -p "Will you use redis? - " isRedisNeeded
read -p "Will you use mysql? - " isMysqlNeeded

function ToLowerCase () {
  if [ $# -eq 0 ]
    then
      echo "ToLowerCase arguments list is missing"
      exit 1 # finish the function with an error code
    else
      typeset -l toLowerCase
      local toLowerCase=$1 # pass the first argument of function what will be a string
      echo $toLowerCase # do return the modified value
      exit 0 # finish the function with a success code
  fi
}

function PushKubernetesDeployToGitlab () {
  local branch=$1
  local repository=$2

  sudo rm -rf .git
  git init
  git remote add origin $gitlabRepository
  git checkout $branch || git checkout -b $branch
  git pull origin $branch --allow-unrelated-histories
  git add .
  git commit -am "kubernetes"

  git push -u origin $gitlabBranch || git push -u origin $gitlabBranch -f
}

isMongodbNeeded=$(ToLowerCase $isMongodbNeeded)
isRedisNeeded=$(ToLowerCase $isRedisNeeded)
isMysqlNeeded=$(ToLowerCase $isMysqlNeeded)

# Set gitlab credentials
gitlabCredentials=(
  $gitlabBranch
  $gitlabRepository
)

# DEFINE A VAR SO THAT TO CHECK IF ONE OF CONDITIONS BELOW PROKED
proked=false

# PULL DB FILES USING THE PROGRAMMER ANSWERS
#IF MONGO & REDIS
if [ $isMongodbNeeded == "yes" ] && [ $isRedisNeeded == "yes" ] && [ $isMysqlNeeded == "no" ]
  then
    proked=true

    wget $MONGODB
    wget $REDIS
    wget $REDIS_MONGODB_TEMPLATE

    mv ./mongo-redis.yml .gitlab-ci.yml #rename to .gitlab-ci.yml
fi

#IF ONLY MONGO
if [ $isMongodbNeeded == "yes" ] && [ $isRedisNeeded == "no" ] && [ $isMysqlNeeded == "no" ]
  then
    proked=true

    wget $MONGODB
    wget $MONGODB_TEMPLATE

    mv ./mongo.yml .gitlab-ci.yml #rename to .gitlab-ci.yml
fi

# IF MYSQL & MONGO
if [ $isMongodbNeeded == "yes" ] && [ $isRedisNeeded == "no" ] && [ $isMysqlNeeded == "yes" ]
  then
   proked=true

   wget $MONGODB
   wget $MONGODB_MYSQL_TEMPLATE

   mv ./mongo-mysql.yml .gitlab-ci.yml #rename to .gitlab-ci.yml
fi

# IF ONLY MYSQL
if [ $isMongodbNeeded == "no" ] && [ $isRedisNeeded == "no" ] && [ $isMysqlNeeded == "yes" ]
 then
   proked=true

   wget $MYSQL_TEMPLATE

   mv ./mysql.yml .gitlab-ci.yml #rename to .gitlab-ci.yml
fi

# IF MYSQL & REDIS
if [ $isMongodbNeeded == "no" ] && [ $isRedisNeeded == "yes" ] && [ $isMysqlNeeded == "yes" ]
 then
   proked=true

   wget $MYSQL_REDIS_TEMPLATE
   wget $REDIS

   mv ./mysql-redis.yml .gitlab-ci.yml #rename to .gitlab-ci.yml
fi

if [ $proked == false ]
 then
   echo "Sorry, we cannot generate deploy files using your answers. Please choose something another or message admins"
   exit 1
 else
   #PULL APP FILES (COMMON APP FILES)
   wget $APP_DOCKERFILE
   wget $APP_TEMPLATE
fi

PushKubernetesDeployToGitlab "${gitlabCredentials[@]}" # pass branch & repository from gitlab
exit 0
