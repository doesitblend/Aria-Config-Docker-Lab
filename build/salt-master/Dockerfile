FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive
ARG plugin_name
ARG salt_version
COPY ./eapi_plugin/files/$plugin_name /$plugin_name
RUN apt-get update
RUN apt-get install -y curl wget supervisor vim
# Run Salt installer to just add a Salt master, but not start it
RUN wget -O /install_salt.sh https://bootstrap.saltproject.io/ \
    && chmod +x /install_salt.sh \
    && /install_salt.sh -X -M stable $salt_version \
    && rm -fv /install_salt.sh
RUN apt-get update && apt-get install salt-api
COPY supervisord.conf /etc/supervisor/supervisord.conf
RUN salt-pip install /$plugin_name
RUN rm /SSEAPE*.whl
ENTRYPOINT [ "/usr/bin/supervisord" ]
CMD [ "-c", "/etc/supervisor/supervisord.conf" ]

