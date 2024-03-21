#!/bin/bash

if ! command -v mkdocs &> /dev/null
then
    echo "mkdocs command could not be found"
    exit 1
fi

if ! command -v helm &> /dev/null
then
    echo "helm command could not be found"
    exit 1
fi

if ! command -v oras &> /dev/null
then
    echo "oras command could not be found"
    exit 1
fi


DIR=`pwd`
rm -rf build
rm -rf docs

# Determine last release version
mkdir build
cd build

# Clone meta information of operator project
git clone git@git.u-s-p.local:core-waap/core-waap-operator.git
cd core-waap-operator

# Get last version GIT tag
export RELEASE=`git tag --sort=creatordate -l *.*.* | tail -1`
echo "-------------------------------------------"
echo "Last operator release: $RELEASE"

# Determine last Helm charts release
export CHARTS_VERSION=`oras repo tags uspregistry.azurecr.io/helm/usp/core/waap/usp-core-waap-operator | tail -1`
echo "Last Helm charts release: $CHARTS_VERSION"

# Check out the operator project release (GIT tag)
git checkout --quiet $RELEASE

# Determine spec-lib version from operator Maven pom
export SPEC_VERSION=`grep 'spec.version' pom.xml`
export SPEC_VERSION=$(echo $SPEC_VERSION | cut -d '>' -f 2)
export SPEC_VERSION=$(echo $SPEC_VERSION | cut -d '<' -f 1)
echo "Spec lib version: $SPEC_VERSION"
echo "-------------------------------------------"

# Get Helm charts to extract values.yaml file
helm pull oci://uspregistry.azurecr.io/helm/usp/core/waap/usp-core-waap-operator --version $CHARTS_VERSION
tar xzf usp-core-waap-operator-$CHARTS_VERSION.tgz

# Download autolearning tool
wget http://nexus-bob.u-s-p.local/repository/releases/ch/u-s-p/core/waap/waap-lib-spec-cli/$SPEC_VERSION/waap-lib-spec-cli-$SPEC_VERSION.jar

# Prepare site source directory
cd $DIR

cp -R src/docs ./docs

# Generate values documentation Markdown file
helm-docs --chart-search-root=build/core-waap-operator/usp-core-waap-operator -o values.md

mkdir -p ./docs/files
cp build/core-waap-operator/CHANGELOG.md ./docs/CHANGELOG.md
cp build/core-waap-operator/usp-core-waap-operator/values.yaml docs/files/
cp build/core-waap-operator/waap-lib-spec-cli-$SPEC_VERSION.jar docs/files/
cp build/core-waap-operator/usp-core-waap-operator/values.md docs/

# Replace version placeholders in all markdown files
for file in ./docs/*; do
    if [ -f "$file" ]; then
        sed -i -e 's/%RELEASE%/'$RELEASE'/g' $file
        sed -i -e 's/%SPEC_VERSION%/'$SPEC_VERSION'/g' $file
        sed -i -e 's/%CHARTS_VERSION%/'$CHARTS_VERSION'/g' $file
    fi
done

# Prepare file downloads
zip -q -r docs/files/usp-core-waap-operator-$RELEASE.zip helm/usp-core-waap-operator
zip -q -r docs/files/juiceshop.zip helm/juiceshop
zip -q -r docs/files/httpbin.zip helm/httpbin

if [ "$1" == "deploy" ]; then
    # Deploy to Github pages
    mkdocs gh-deploy
fi

