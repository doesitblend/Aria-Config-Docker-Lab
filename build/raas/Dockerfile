FROM registry.redhat.io/ubi9/ubi:9.5-1732804088
ARG filename
ARG salt_version
RUN rpm --import https://packages.broadcom.com/artifactory/api/security/keypair/SaltProjectKey/public
COPY salt.repo /etc/yum.repos.d/salt.repo
COPY ./eapi_service/files/$filename $filename
COPY ./init.sh /usr/local/bin/init.sh
COPY ./eapi_service/files/sample-resource-types.raas /tmp/sample-resource-types.raas
RUN  dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm
RUN dnf update -y
RUN dnf install -y salt-minion-${salt_version}-0
RUN dnf install -y /$filename procps-ng
RUN dnf install -y python3-setproctitle
RUN rm raas*.rpm
RUN chmod 755 /usr/local/bin/init.sh
USER raas
ENTRYPOINT ["/usr/local/bin/init.sh"]
CMD ["-l", "info"]
