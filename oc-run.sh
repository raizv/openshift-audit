#!/bin/sh
set -o nounset -o errexit

# Runs `yarn run test` against a container on OpenShift. Used by the Test stage of the Jenkinsfile.
# Usage: ./oc-run.sh container_name version

APP_NAME="openshift-audit"
IMAGESTREAM=`oc get imagestream ${APP_NAME} -o='jsonpath={.status.dockerImageRepository}'`
ENVIRONMENT=${1:-dev}

oc run ${APP_NAME} \
  --image=${IMAGESTREAM} \
  --rm=true \
  --attach=true \
  --restart=Never \
  --overrides='{
  "apiVersion":"v1",
  "spec":{
    "containers":[{
      "name": "'${APP_NAME}'",
      "image": "'${IMAGESTREAM}'",
      "env":[{
        "name":"API_HOST",
        "valueFrom":{
          "secretKeyRef":{
            "key": "host",
            "name":"'${APP_NAME}'-'${ENVIRONMENT}'"
          }
        }
      },{
        "name":"API_TOKEN",
        "valueFrom":{
          "secretKeyRef":{
            "key": "token",
            "name":"'${APP_NAME}'-'${ENVIRONMENT}'"
          }
        }
      }]
    }]
  }
}'
