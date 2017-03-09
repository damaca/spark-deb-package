#!/bin/bash
mkdir /var/lib/spark
mkdir /var/run/spark
chown -R spark:spark /opt/spark* /var/lib/spark /var/log/spark
