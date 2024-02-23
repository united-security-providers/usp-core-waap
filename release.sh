#!/bin/bash

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

echo "Last operator release: $RELEASE"
git checkout $RELEASE

export SPEC_VERSION=`grep 'spec.version' pom.xml`
export SPEC_VERSION=$(echo $SPEC_VERSION | cut -d '>' -f 2)
export SPEC_VERSION=$(echo $SPEC_VERSION | cut -d '<' -f 1)
echo "Spec lib version: $SPEC_VERSION"

# Download autolearning tool
wget http://nexus-bob.u-s-p.local/repository/releases/ch/u-s-p/core/waap/waap-lib-spec-cli/$SPEC_VERSION/waap-lib-spec-cli-$SPEC_VERSION.jar

# Prepare site source directory
cd $DIR
#echo "placeholders:" > placeholder-plugin.yaml
#echo "  placeholder_css: ''" >> placeholder-plugin.yaml
#echo "  RELEASE: $RELEASE"  >> placeholder-plugin.yaml
#echo "  SPEC_VERSION: $SPEC_VERSION"  >> placeholder-plugin.yaml
#echo "settings:" >> placeholder-plugin.yaml
#echo "  auto_placeholder_tables: false" >> placeholder-plugin.yaml

cp -R src/docs ./docs
mkdir -p ./docs/files
cp build/core-waap-operator/CHANGELOG.md ./docs/CHANGELOG.md

# Replace version placeholders
for file in ./docs/*; do
    if [ -f "$file" ]; then
        sed -i -e 's/%RELEASE%/'$RELEASE'/g' $file
        sed -i -e 's/%SPEC_VERSION%/'$SPEC_VERSION'/g' $file
    fi
done

#sed -i -e 's/%RELEASE%/'$RELEASE'/g' docs/index.md
#sed -i -e 's/%RELEASE%/'$RELEASE'/g' docs/downloads.md
#sed -i -e 's/%SPEC_VERSION%/'$SPEC_VERSION'/g' docs/downloads.md
#sed -i -e 's/%RELEASE%/'$RELEASE'/g' docs/autolearning.md

# Prepare file downloads
zip -q -r docs/files/usp-core-waap-operator-$RELEASE.zip helm/usp-core-waap-operator
zip -q -r docs/files/juiceshop.zip helm/juiceshop
zip -q -r docs/files/httpbin.zip helm/httpbin
cp build/core-waap-operator/waap-lib-spec-cli-$SPEC_VERSION.jar docs/files/

if [ "$1" == "deploy" ]; then
    # Deploy to Github pages
    mkdocs gh-deploy
fi

