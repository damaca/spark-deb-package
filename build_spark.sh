#!/bin/bash
# 2015-Mar-18 Updated to latest Kafka stable: 0.8.2.1
set -e
set -u
name=spark
version=${1:-"1.6.1"}
scala_version=${2:-"2.10.0"}
description="Apache Spark is a fast and general engine for large-scale data processing."
url="https://spark.apache.org/"
arch="all"
section="misc"
license="Apache Software License 2.0"
package_version="-1"
#package_type="bin-without-hadoop"
package_type="hadoop2.6"
src_package="spark-${version}-${package_type}.tgz"
download_url="http://archive.apache.org/dist/spark/spark-${version}/${src_package}"
origdir=$(python -c 'import os,sys;print os.path.realpath(sys.argv[1])' $0/..)

#_ MAIN _#
rm -rf ${name}*.deb
if [[ ! -f "${src_package}" ]]; then
  wget ${download_url} -P $origdir
fi
mkdir -p tmp && pushd tmp
rm -rf spark
mkdir -p spark
cd spark
mkdir -p build/opt/spark
mkdir -p build/etc/default
mkdir -p build/etc/init
mkdir -p build/var/log/spark

cp ${origdir}/spark.default build/etc/default/spark
cp ${origdir}/spark.upstart.conf build/etc/init/spark.conf

tar zxf ${origdir}/${src_package}
cd spark-${version}-${package_type}
#sbt update
#sbt package
#mv config/log4j.properties config/server.properties ../build/etc/spark
#mv * ../build/usr/lib/spark
mv * ../build/opt/spark
cd ../build

fpm -t deb \
    -n ${name} \
    -v ${version}${package_version} \
    --description "${description}" \
    --url="{$url}" \
    -a ${arch} \
    --category ${section} \
    --vendor "" \
    --license "${license}" \
    --before-install ${origdir}/pre-install.sh \
    --after-install ${origdir}/post-install.sh \
    --after-remove ${origdir}/post-uninstall.sh \
    -m "root@localhost" \
    --prefix=/ \
    -s dir \
    -- .
mv spark*.deb ${origdir}/..
popd
