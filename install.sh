#!/bin/sh
set -o nounset -o errexit
cd `dirname $0`

# Installs the build pipeline for a given branch (default: master) in your currently selected OpenShift project
# See: README.md
BRANCH=${1:-master}
APP_NAME=${2:-openshift-audit}
ENVIRONMENT=${3:-dev}

# Create secrets to pull source code from repo
# 

# Apply and execute the OpenShift template
oc apply -f openshift-template.yml
oc process ${APP_NAME} BRANCH=${BRANCH}| oc apply -f -
oc start-build ${APP_NAME}

# Create service account and get api token
oc create sa ${APP_NAME}

# add cluster-reader role to service account
oc adm policy add-cluster-role-to-user cluster-reader system:serviceaccount:default:${APP_NAME}

# create openshift secret from api token
oc create secret generic ${APP_NAME}-${ENVIRONMENT} --from-literal=token=$(oc sa get-token ${APP_NAME}) --dry-run -o yaml | oc apply -f -
