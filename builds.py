#!/usr/bin/env python3

import datetime
from kubernetes import client, config
from openshift.dynamic import DynamicClient

k8s_client = config.new_client_from_config()
dyn_client = DynamicClient(k8s_client)

v1_builds = dyn_client.resources.get(api_version='build.openshift.io/v1', kind='Build')
builds = v1_builds.get()

for b in builds.items:
    # find builds with Running longer that 15 mins
    if b.status.phase == 'Running' and b.status.stages[-1].steps[-1].durationMilliseconds > 900000:
        duration_milliseconds = b.status.stages[-1].steps[-1].durationMilliseconds
        duration = str(datetime.timedelta(seconds=duration_milliseconds))
        print("{0} {1}: running for {2}".format(b.metadata.namespace, b.metadata.name, duration))