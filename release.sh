#!/bin/bash

DIR=`pwd`
rm -rf build
rm -rf docs

# Determine last release version
mkdir build
cd build
# Clone meta information of operator project
git clone -n git@git.u-s-p.local:core-waap/core-waap-operator.git
cd core-waap-operator
# Get last version GIT tag
export RELEASE=`git tag --sort=creatordate -l *.*.* | tail -1`

echo "Last operator release: $RELEASE"

# Download changelog of operator release
wget http://nexus-bob.u-s-p.local/repository/releases/ch/u-s-p/core/waap/waap-operator/$RELEASE/waap-operator-$RELEASE-changelog.md

# Prepare site source directory
cd $DIR
cp -R src/docs ./docs
cp build/core-waap-operator/waap-operator-0.2.0-changelog.md ./docs/CHANGELOG.md

# Deploy to Github pages
mkdocs gh-deploy

