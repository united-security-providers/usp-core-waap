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
rm -rf output.log
rm -rf generated

# Determine last release version
mkdir build
cd build

# Clone meta information of ci and operator project
git clone git@git.u-s-p.local:core-waap/core-waap-ci.git
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

# Remove all link brackets
sed 's|[\[,]||g' build/CHANGELOG2.md > build/CHANGELOG3.md
sed 's|[],]||g' build/CHANGELOG3.md > build/CHANGELOG-clean.md

mkdir -p ./docs/files
cp build/CHANGELOG-clean.md ./docs/CHANGELOG.md
cp build/core-waap-operator/usp-core-waap-operator/values.yaml docs/files/
cp build/core-waap-operator/waap-lib-autolearn-cli-$SPEC_VERSION.jar docs/files/
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
zip -q -r docs/files/juiceshop.zip build/core-waap-ci/demo/juiceshop
zip -q -r docs/files/httpbin.zip build/core-waap-ci/demo/httpbin

if [ "$1" == "deploy" ]; then
    # Deploy to Github pages
    mkdocs gh-deploy
fi

