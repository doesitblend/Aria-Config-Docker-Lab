FROM quay.io/centos/centos:stream9
ARG salt_version
RUN rpm --import https://packages.broadcom.com/artifactory/api/security/keypair/SaltProjectKey/public
#RUN curl -fsSL https://repo.saltproject.io/salt/py3/redhat/9/x86_64/minor/$salt_version.repo | tee /etc/yum.repos.d/salt.repo
COPY salt.repo /etc/yum.repos.d/salt.repo
RUN dnf update -y
RUN dnf install -y salt-minion-3006.9-0
ENTRYPOINT [ "/usr/bin/salt-minion" ]
CMD [ "-l", "info" ]

