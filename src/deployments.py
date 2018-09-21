#!/usr/bin/env python3
import os

from kubernetes import client, config
from openshift.dynamic import DynamicClient

# disable ssl warninings
import urllib3
urllib3.disable_warnings()

def main():
    api_token = os.environ['API_TOKEN']
    api_host = os.environ['API_HOST']
    verify_ssl = False

    configuration = client.Configuration()
    configuration.api_key_prefix = {'authorization': 'Bearer'}
    configuration.api_key = {'authorization': api_token}
    configuration.host = api_host
    configuration.verify_ssl = verify_ssl
    api_client = client.ApiClient(configuration=configuration)
    dyn_client = DynamicClient(api_client)

    system_projects = ['default', 'kube-public', 'kube-system', 'logging', 'openshift', 'openshift-infra', 
        'openshift-node',  'openshift-web-console']

    v1_projects = dyn_client.resources.get(api_version='project.openshift.io/v1', kind='Project')
    project_list = v1_projects.get()

    projects = [p for p in project_list.items if p.metadata.name not in system_projects]

    for p in projects:
        v1_deployment_configs = dyn_client.resources.get(api_version='apps.openshift.io/v1', kind='DeploymentConfig')
        deployments = v1_deployment_configs.get()
        for d in deployments.items:
            if ('jenkins' not in d.metadata.name):
                if d.spec.replicas < 3:
                    print("Project: {0} Deployment: {1} Replicas: {2}".format(p.metadata.name, d.metadata.name, d.spec.replicas))

                containers = d.spec.template.spec.containers
                for c in containers:
                    if (not c.liveness_probe):
                        print("Project: {0} Deployment: {1} Healthchecks: Liveness Probe is missing".format(p.metadata.name, d.metadata.name))
                    if (not c.readiness_probe):
                        print("Project: {0} Deployment: {1} Healthchecks: Readinness Probe is missing".format(p.metadata.name, d.metadata.name))


if __name__ == '__main__':
    main()