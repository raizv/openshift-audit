#!/usr/bin/env python3

import os
import datetime
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

    v1_builds = dyn_client.resources.get(api_version='build.openshift.io/v1', kind='Build')
    builds = v1_builds.get()

    for b in builds.items:
        # find builds running longer than 15 mins
        if b.status.phase == 'Running' and b.status.stages[-1].steps[-1].durationMilliseconds > 900000:
            duration_milliseconds = b.status.stages[-1].steps[-1].durationMilliseconds
            duration = str(datetime.timedelta(seconds=duration_milliseconds))
            print("{0} {1}: running for {2}".format(b.metadata.namespace, b.metadata.name, duration))