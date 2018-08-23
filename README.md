# Openshift API Client

Uses [openshift-restclient-python][openshift-restclient-python] to work with Openshift API.

*NOTE*: Works only with Python 2 and openshift:0.4.1. See [requirements.txt][requirements.txt].

## Installation

```bash
pip install -r requirements.txt --user
```

## Credentials
### API Host

```bash
oc config current-context | cut -d/ -f1
```

### API Token
``` 
# create service account
oc create serviceaccount ${APP_NAME}

# add role to service account
oc policy add-role-to-user admin system:serviceaccounts:default:${APP_NAME}

# get api token
oc serviceaccounts get-token ${APP_NAME}
```

## Usage
```
$ ./oc-run.sh

Project: myproject
	Deployment: mydeployment
		Replicas: 1
		Liveness Probe: None
		Readiness Probe: None
```


*NOTE*: With great power, comes great responsibility...

[openshift-restclient-python]: https://github.com/openshift/openshift-restclient-python
[requirements.txt]: ./requirements.txt