# Defines the production environment for our application

FROM python:2.7-alpine

ENV HOME=/app \
    # oc whoami --show-token
    # or 
    # oc create serviceaccount service_account_name
    # oc policy add-role-to-user admin system:serviceaccounts:test:service_account_name
    # oc serviceaccounts get-token service_account_name
    API_TOKEN='YOUR_API_TOKEN' \
    # oc config current-context | cut -d/ -f1
    API_HOST='https://localhost:8443' \
    # set to 0 to avoid 'SSLError certificate verify failed'
    VERIFY_SSL=0

WORKDIR /app

RUN set -ex && \
    chgrp -R 0 /app && \
    chmod -R g=u /app && \
    apk add --update --no-cache g++ make libffi libffi-dev python-dev openssl-dev

COPY requirements.txt openshift-client.py /app/

RUN set -ex && \
    pip install -r requirements.txt && \
    apk del g++ make libffi libffi-dev python-dev openssl-dev

USER 1001
ENTRYPOINT ["python2"]
CMD ["openshift-client.py"]
