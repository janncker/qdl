#!/bin/bash
set -e

TOPDIR=$(dirname $(realpath $0))/..

echo $TOPDIR

pushd $TOPDIR

GIT_REVSION=$(git log --pretty="%h"|wc|awk '{print $1}')

VERSION=$(git describe --tags)
VERSION=${VERSION/v/}
WORKDIR="qdl-${VERSION}"

if [ -d $WORKDIR ]; then
    rm -rf $WORKDIR
fi

mkdir $WORKDIR/DEBIAN -p
mkdir $WORKDIR/usr/local/bin -p

cat <<EOF > $WORKDIR/DEBIAN/control
Package: qdl
Version: $VERSION
Section: custom
Priority: optional
Architecture: amd64
Depends: libxml2
Essential: no
Maintainer: Janncker
Description: Qualcomm Download

EOF

make

cp -a $TOPDIR/qdl $WORKDIR/usr/local/bin/

dpkg-deb --build $WORKDIR

popd
