#!/usr/bin/env python2
import openshift.client
import os

# disable ssl warninings
import urllib3
urllib3.disable_warnings()

def main():
    api_token = os.environ['API_TOKEN']
    api_host = os.environ['API_HOST']
    verify_ssl = int(os.environ['VERIFY_SSL'])

    configuration = openshift.client.Configuration()
    configuration.api_key_prefix = {'authorization': 'Bearer'}
    configuration.api_key = {'authorization': api_token}
    configuration.host = api_host
    configuration.verify_ssl = verify_ssl
    api_client = openshift.client.ApiClient(configuration=configuration)
    oapi = openshift.client.OapiApi(api_client)

    system_projects = ['default', 'kube-public', 'kube-system', 'logging', 'openshift', 'openshift-infra', 
        'openshift-node',  'openshift-web-console']

    projects = [p for p in oapi.list_project().items if p.metadata.name not in system_projects]

    for p in projects:
        print("Project: {}".format(p.metadata.name))

        deployments = oapi.list_namespaced_deployment_config(p.metadata.name)
        for d in deployments.items:
            if ('jenkins' not in d.metadata.name):
                print("\tDeployment: {}".format(d.metadata.name))
                print("\t\tReplicas: {}".format(d.spec.replicas))

                containers = d.spec.template.spec.containers
                for c in containers:
                    if (not c.liveness_probe):
                        print("\t\tLiveness Probe: {}".format(c.liveness_probe))
                    if (not c.readiness_probe):
                        print("\t\tReadiness Probe: {}".format(c.readiness_probe))


if __name__ == '__main__':
    main()