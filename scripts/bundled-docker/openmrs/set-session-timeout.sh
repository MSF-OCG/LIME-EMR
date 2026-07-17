#!/bin/sh
# LIME-EMR: patch the container's own conf/web.xml in place rather than
# vendoring the whole file, so Tomcat base image upgrades keep their own
# defaults everywhere except this one value.
set -e
sed -i 's/<session-timeout>[0-9]*<\/session-timeout>/<session-timeout>25<\/session-timeout>/' /usr/local/tomcat/conf/web.xml
grep -q '<session-timeout>25</session-timeout>' /usr/local/tomcat/conf/web.xml
