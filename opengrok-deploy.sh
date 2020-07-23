#!/bin/bash

# Depends opengrok-tools in dist/current/tools/opengrok-tools.tar.gz
# Using pip3 install opengrok-tools.tar.gz to install it.
#

if [ `whoami` != "root" ]; then
	echo -e Please run as root!
	exit
fi

if [ A$1 == A ]; then
	echo -e Please supply project name!
	exit
fi

PROJNAME=$1
if [ ! -d /var/opengrok/src/$PROJNAME ]; then
	echo -e Project directory is not found!
	echo -e Please download the source code into /var/opengrok/src/ directory first!
	exit
fi

if [ -d /var/opengrok/etc/$PROJNAME ]; then
	echo -e Project $PROJNAME is already deployed!
	echo -e If you want to upgrade source code index, please execute opengrok-index.sh
	exit
fi

mkdir -p /var/opengrok/data/$PROJNAME
mkdir -p /var/opengrok/etc/$PROJNAME

echo Start indexing
opengrok-indexer -J=-Djava.util.logging.config.file=/var/opengrok/logging.properties \
	-a /var/opengrok/dist/current/lib/opengrok.jar -- \
	-c /usr/local/bin/ctags \
	-s /var/opengrok/src/$PROJNAME -d /var/opengrok/data/$PROJNAME -H -P -S -G \
	-W /var/opengrok/etc/$PROJNAME/configuration.xml

echo Start deploying
opengrok-deploy /var/opengrok/dist/current/lib/source.war /var/lib/tomcat8/webapps/$PROJNAME.war -c /var/opengrok/etc/$PROJNAME/configuration.xml

echo OK!
