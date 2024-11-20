FROM ubuntu:22.04
ARG plugin_name
ARG salt_version="3006.9"
COPY ./eapi_plugin/files/$plugin_name /$plugin_name
RUN apt-get update
RUN apt-get install -y curl less vim coreutils
RUN mkdir -p /etc/apt/keyrings && curl -fsSL https://packages.broadcom.com/artifactory/api/security/keypair/SaltProjectKey/public | tee /etc/apt/keyrings/salt-archive-keyring.pgp
RUN curl -fsSL https://github.com/saltstack/salt-install-guide/releases/latest/download/salt.sources | tee /etc/apt/sources.list.d/salt.sources
RUN apt-get update
RUN apt-get install -y salt-master=${salt_version} salt-minion=${salt_version} salt-common=${salt_version}
RUN salt-pip install /$plugin_name
RUN rm SSEAPE*.whl
ENTRYPOINT [ "/usr/bin/salt-master" ]
CMD [ "-l", "info" ]

