# Defines the production environment for our application

FROM python:2.7-alpine

ENV HOME=/app
WORKDIR /app

RUN set -ex && \
    chgrp -R 0 /app && \
    chmod -R g=u /app && \
    apk add --update --no-cache g++ make libffi libffi-dev python-dev openssl-dev

COPY requirements.txt openshift-client.py /app/

RUN set -ex && \
    pip install -r requirements.txt

USER 1001
ENTRYPOINT ["python2"]
CMD ["openshift-client.py"]
