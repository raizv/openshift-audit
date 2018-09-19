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
oc create sa openshift-audit

# add cluster-reader role to service account
oc adm policy add-cluster-role-to-user cluster-reader system:serviceaccount:default:openshift-audit

# get api token
oc sa get-token openshift-audit
```

## Openshift Secret to get API access
```
oc create secret generic openshift-audit-dev --from-literal=token=$(oc sa get-token openshift-audit) --dry-run -o yaml | oc apply -f -

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