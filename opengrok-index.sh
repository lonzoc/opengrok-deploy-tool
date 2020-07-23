#!/bin/bash

# Upgrade the source code index

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
	exit
fi

if [ ! -d /var/opengrok/data/$PROJNAME ]; then
	mkdir -p /var/opengrok/data/$PROJNAME
fi

if [ ! -d /var/opengrok/etc/$PROJNAME ]; then
	mkdir -p /var/opengrok/etc/$PROJNAME
fi

opengrok-indexer -J=-Djava.util.logging.config.file=/var/opengrok/logging.properties \
	-a /var/opengrok/dist/current/lib/opengrok.jar -- \
	-c /usr/local/bin/ctags \
	-s /var/opengrok/src/$PROJNAME -d /var/opengrok/data/$PROJNAME -H -P -S -G \
	-W /var/opengrok/etc/$PROJNAME/configuration.xml -U http://localhost/$PROJNAME
