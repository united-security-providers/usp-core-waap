#!/bin/bash

set -eE # same as: `set -o errexit -o errtrace`
trap 'catch $? $LINENO' ERR

catch() {
  echo "Error $1 occurred on line $2"
}

checkbin() {
  local cmd=$1
  if ! command -v $cmd &> /dev/null; then
    echo "$cmd command could not be found"
    exit
  fi
}

checkbin mkdocs
checkbin helm
checkbin oras

DIR=`pwd`
rm -rf build
rm -rf docs
rm -rf output.log
rm -rf generated

# Determine last release version
mkdir build
cd build

# Determine last Helm charts release
export CHARTS_VERSION=`oras repo tags uspregistry.azurecr.io/helm/usp/core/waap/usp-core-waap-operator | tail -1`
echo "Last Helm charts release: $CHARTS_VERSION"

# clone ci project and checkout tag matching the helm charts release
git clone git@git.u-s-p.local:core-waap/core-waap-ci.git
cd core-waap-ci
git checkout --quiet helm$CHARTS_VERSION
cd ..

# clone helm chart project and checkout tag matching the helm charts release
git clone git@git.u-s-p.local:core-waap/core-waap-operator-helm.git
cd core-waap-operator-helm
git checkout --quiet $CHARTS_VERSION
# Determine core-waap (Envoy) version from Helm values.yaml file
export CORE_WAAP_VERSION=`grep '/usp/core/waap/usp-core-waap:' helm/usp-core-waap-operator/values.yaml`
export CORE_WAAP_VERSION=$(echo $CORE_WAAP_VERSION | cut -d ':' -f 3)
export CORE_WAAP_VERSION=$(echo $CORE_WAAP_VERSION | cut -d '"' -f 1)
cd ..

# clone core-waap container project
git clone git@git.u-s-p.local:core-waap/core-waap-build.git
cd core-waap-build
git checkout --quiet v$CORE_WAAP_VERSION
cd ..

# clone operator project
git clone git@git.u-s-p.local:core-waap/core-waap-operator.git
cd core-waap-operator

# Get last version GIT tag
export RELEASE=`git tag --sort=creatordate -l *.*.* | tail -1`
echo "----------------------------------------------------"
echo "Last Helm chart release in OCI repository: $CHARTS_VERSION"
echo "Core-WAAP version from 'values.yaml': $CORE_WAAP_VERSION"
echo "Last operator release by GIT tag: $RELEASE"

# Check out the operator project release (GIT tag)
git checkout --quiet $RELEASE

# Determine spec-lib version from operator Maven pom
export SPEC_VERSION=`grep 'spec.version' pom.xml`
export SPEC_VERSION=$(echo $SPEC_VERSION | cut -d '>' -f 2)
export SPEC_VERSION=$(echo $SPEC_VERSION | cut -d '<' -f 1)
echo "Spec lib version from POM: $SPEC_VERSION"


echo "----------------------------------------------------"

# Get Helm charts to extract values.yaml file
helm pull oci://uspregistry.azurecr.io/helm/usp/core/waap/usp-core-waap-operator --version $CHARTS_VERSION
tar xzf usp-core-waap-operator-$CHARTS_VERSION.tgz

# Download autolearning tool
wget http://nexus-bob.u-s-p.local/repository/releases/ch/u-s-p/core/waap/waap-lib-autolearn-cli/$SPEC_VERSION/waap-lib-autolearn-cli-$SPEC_VERSION.jar

# Prepare site source directory
cd $DIR

java -jar ./build/core-waap-operator/waap-lib-autolearn-cli-$SPEC_VERSION.jar --help > output.log

cp -R src/docs ./docs

echo "\`\`\`"  >> ./docs/autolearning.md
cat output.log >> ./docs/autolearning.md
echo "\`\`\`"  >> ./docs/autolearning.md
echo " "  >> ./docs/autolearning.md
echo "[downloaded here]: /downloads/" >> ./docs/autolearning.md

# Generate values documentation Markdown file
helm-docs --chart-search-root=build/core-waap-operator/usp-core-waap-operator -o values.md

# Remove footer section with all link URLs from changelog
sed -n '/linksnurls/q;p' build/core-waap-operator/CHANGELOG.md > build/CHANGELOG2.md
# Until a new operator release is made with the "linksnurls" footer marker, the
# following line has to be used to cut off the footer instead:
sed -n '/redmine/q;p' build/core-waap-operator/CHANGELOG.md > build/CHANGELOG2.md

# Remove all link brackets from operator changelog
sed 's|[\[,]||g' build/CHANGELOG2.md > build/CHANGELOG3.md
sed 's|[],]||g' build/CHANGELOG3.md > build/CHANGELOG-clean.md

mkdir -p ./docs/files
cp build/CHANGELOG-clean.md ./docs/operator-CHANGELOG.md
cp build/core-waap-operator/usp-core-waap-operator/values.yaml docs/files/
cp build/core-waap-operator/waap-lib-autolearn-cli-$SPEC_VERSION.jar docs/files/
cp build/core-waap-operator/usp-core-waap-operator/values.md docs/

# Remove all link brackets from core-waap container changelog
sed 's|[\[,]||g' build/core-waap-build/CHANGELOG.md > build/core-waap-CHANGELOG2.md
sed 's|[],]||g' build/core-waap-CHANGELOG2.md > build/core-waap-CHANGELOG-clean.md
cp build/core-waap-CHANGELOG-clean.md ./docs/core-waap-CHANGELOG.md

# Remove all link brackets from helm chart changelog
sed 's|[\[,]||g' build/core-waap-operator-helm/CHANGELOG.md > build/helm-CHANGELOG2.md
sed 's|[],]||g' build/helm-CHANGELOG2.md > build/helm-CHANGELOG-clean.md
cp build/helm-CHANGELOG-clean.md ./docs/helm-CHANGELOG.md

# Replace version placeholders in all markdown files
for file in ./docs/*; do
    if [ -f "$file" ]; then
        sed -i -e 's/%RELEASE%/'$RELEASE'/g' $file
        sed -i -e 's/%SPEC_VERSION%/'$SPEC_VERSION'/g' $file
        sed -i -e 's/%CHARTS_VERSION%/'$CHARTS_VERSION'/g' $file
    fi
done

# Prepare file downloads
zip -q -r docs/files/juiceshop.zip build/core-waap-ci/demo/juiceshop
zip -q -r docs/files/httpbin.zip build/core-waap-ci/demo/httpbin

if [ "$1" == "deploy" ]; then
    # Deploy to Github pages
    mkdocs gh-deploy
fi

trap - ERR
