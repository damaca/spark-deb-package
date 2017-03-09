#!/bin/bash
BIN_USERADD=`/usr/bin/which useradd`
$BIN_USERADD -d /opt/spark -s /bin/bash spark
