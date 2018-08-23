#!/bin/sh
set -o nounset -o errexit

# Runs `yarn run test` against a container on OpenShift. Used by the Test stage of the Jenkinsfile.
# Usage: ./oc-run.sh container_name version

CONTAINER_NAME="openshift-api-client"
ENVIRONMENT=${1:-dev}
IMAGESTREAM=`oc get imagestream ${CONTAINER_NAME} -o='jsonpath={.status.dockerImageRepository}'`

# if $(oc get pod ${CONTAINER_NAME}); then
#  oc delete pod ${CONTAINER_NAME}
# fi

oc run ${CONTAINER_NAME} \
  --image=${IMAGESTREAM} \
  --rm=true \
  --attach=true \
  --restart=Never \
  --overrides='{
  "apiVersion":"v1",
  "spec":{
    "containers":[{
      "name": "'${CONTAINER_NAME}'",
      "image": "'${IMAGESTREAM}'",
      "env":[{
        "name":"API_HOST",
        "valueFrom":{
          "secretKeyRef":{
            "key": "host",
            "name":"openshift-api-token-'${ENVIRONMENT}'"
          }
        }
      },{
        "name":"API_TOKEN",
        "valueFrom":{
          "secretKeyRef":{
            "key": "token",
            "name":"openshift-api-token-'${ENVIRONMENT}'"
          }
        }
      }]
    }]
  }
}'
