activemq-artemis
================

[![Docker Pulls](https://img.shields.io/docker/pulls/calincerchez/activemq-artemis)](https://hub.docker.com/r/calincerchez/activemq-artemis)

Image Tags
----------
calincerchez/activemq-artemis:latest

How to use this image
---------------------

Run the latest container with:

    docker pull calincerchez/activemq-artemis
    docker run -p 61616:61616 -p 8161:8161 calincerchez/activemq-artemis
    
The JMX broker listens on port 61616 and the Web Console on port 8161.

By default data and configuration is stored inside the container and will be
lost after the container has been shut down and removed. To change the configuration
or to persist these files you can mount these directories to directories on your 
host system:

    docker run -p 61616:61616 -p 8161:8161 \
               -v /your/persistent/dir/conf:/var/lib/artemis-instance/etc-overrides \
               -v /your/persistent/dir/data:/var/lib/artemis-instance/data \
               calincerchez/activemq-artemis
