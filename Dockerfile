# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

# ActiveMQ Artemis

FROM openjdk:8
LABEL maintainer="Apache ActiveMQ Team"
# Make sure pipes are considered to determine success, see: https://github.com/hadolint/hadolint/wiki/DL4006
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ENV ARTEMIS_VERSION 2.17.0
ENV ARTEMIS_DIST_FILE_NAME apache-artemis-$ARTEMIS_VERSION-bin.tar.gz
ENV ARTEMIS_TMPDIR /tmp
ENV ARTEMIS_HOME /opt/activemq-artemis
ENV ARTEMIS_USER artemis
ENV ARTEMIS_PASSWORD artemis
ENV ANONYMOUS_LOGIN false
ENV EXTRA_ARGS --http-host 0.0.0.0 --relax-jolokia

# Install artemis and add user and group for artemis
RUN curl "https://mirrors.hostingromania.ro/apache.org/activemq/activemq-artemis/$ARTEMIS_VERSION/$ARTEMIS_DIST_FILE_NAME" --output "$ARTEMIS_TMPDIR/$ARTEMIS_DIST_FILE_NAME" && \
	mkdir $ARTEMIS_HOME && \
	tar zxf $ARTEMIS_TMPDIR/$ARTEMIS_DIST_FILE_NAME --directory $ARTEMIS_HOME --strip 1 && \
	groupadd -g 1000 -r artemis && useradd -r -u 1000 -g artemis artemis && \
	apt-get -qq -o=Dpkg::Use-Pty=0 update && \
	apt-get -qq -o=Dpkg::Use-Pty=0 install -y libaio1 && \
	rm -rf /var/lib/apt/lists/* && \
	chown -R artemis:artemis $ARTEMIS_HOME

# Web Server
EXPOSE 8161 \
# JMX Exporter
    9404 \
# Port for CORE,MQTT,AMQP,HORNETQ,STOMP,OPENWIRE
    61616 \
# Port for HORNETQ,STOMP
    5445 \
# Port for AMQP
    5672 \
# Port for MQTT
    1883 \
#Port for STOMP
    61613

USER root

RUN mkdir /var/lib/artemis-instance && chown -R artemis.artemis /var/lib/artemis-instance

COPY ./docker-run.sh /

USER artemis

# Expose some outstanding folders
VOLUME ["/var/lib/artemis-instance/etc", "/var/lib/artemis-instance/data"]
WORKDIR /var/lib/artemis-instance

ENTRYPOINT ["/docker-run.sh"]
CMD ["run"]