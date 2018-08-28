#!/bin/sh
set -o nounset -o errexit
cd `dirname $0`

# Installs the build pipeline for a given branch (default: master) in your currently selected OpenShift project
# See: README.md

APP_NAME=${1:-openshift-audit}
ENVIRONMENT=${2:-dev}

# Create secrets to pull source code from repo
# 

# Apply and execute the OpenShift template
oc apply -f openshift-template.yml
oc process ${APP_NAME} | oc apply -f -
oc start-build ${APP_NAME}


# Create service account and get api token
# oc create serviceaccount ${APP_NAME}
# oc policy add-role-to-user admin system:serviceaccounts:default:${APP_NAME}
# oc serviceaccounts get-token ${APP_NAME}
# oc create secret generic ${APP_NAME}-${ENVIRONMENT} --from-literal=token=$(oc serviceaccounts get-token ${APP_NAME}) --dry-run -o yaml | oc apply -f -

# replace default values
# sed s/YOUR_SECRET_NAME/ /g secrets.yml
# sed s/YOUR_API_HOST/ /g secrets.yml
# sed s/YOUR_API_TOKEN/ /g  secrets.yml 

