FROM debian:12.4
ARG salt_version
RUN apt-get update
RUN apt-get install -y curl
RUN mkdir -p /etc/apt/keyrings && curl -fsSL https://packages.broadcom.com/artifactory/api/security/keypair/SaltProjectKey/public | tee /etc/apt/keyrings/salt-archive-keyring.pgp
RUN curl -fsSL https://github.com/saltstack/salt-install-guide/releases/latest/download/salt.sources | tee /etc/apt/sources.list.d/salt.sources
RUN apt-get update
RUN apt-get install -y salt-minion
ENTRYPOINT [ "/usr/bin/salt-minion" ]
CMD [ "-l", "info" ]

