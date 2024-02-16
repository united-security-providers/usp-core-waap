#!/bin/bash

DIR=`pwd`
rm -rf build
rm -rf docs

# Determine
mkdir build
cd build
echo "--> clone..."
git clone -n git@git.u-s-p.local:core-waap/core-waap-operator.git
echo "--> done."
cd core-waap-operator
export RELEASE=`git tag --sort=creatordate -l *.*.* | tail -1`

echo "Last operator release: $RELEASE"

wget http://nexus-bob.u-s-p.local/repository/releases/ch/u-s-p/core/waap/waap-operator/$RELEASE/waap-operator-$RELEASE-changelog.md

# Prepare site source directory
cd $DIR
cp -R src/docs ./docs
cp build/core-waap-operator/waap-operator-0.2.0-changelog.md ./docs/CHANGELOG.md