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

prepareChangelog() {
  local sourceFile=$1
  local targetFile=$2

  rm -rf changelog-tmp
  mkdir changelog-tmp

  # Remove all "[...]: ..." link declarations (typ. at the bottom of the file)
  sed -e "s/^\[[^\]*\]: http.*//g" $sourceFile > changelog-tmp/CHANGELOG2.md

  # Remove all link brackets []
  sed 's|[\[,]||g' changelog-tmp/CHANGELOG2.md > changelog-tmp/CHANGELOG3.md
  sed 's|[],]||g' changelog-tmp/CHANGELOG3.md > $targetFile

  rm -rf changelog-tmp
}

downloadFromNexus() {
  local version=$1
  local groupId=$2
  local artifactId=$3
  local type=$4
  local classifier=$5

  local repository='releases'
  if [[ $version =~ "SNAPSHOT" ]]; then
    repository='snapshots'
  fi

  local query="http://nexus-bob.u-s-p.local/service/rest/v1/search/assets?sort=version&maven.baseVersion=$version&maven.groupId=$groupId&maven.artifactId=$artifactId&maven.extension=$type&maven.classifier=$classifier"
  echo "Nexus query for Core WAAP changelog: $query"

  wget -O info.json $query
  downloadUrl=`cat info.json | grep -v '\-sources' | grep -a -m 1 -h "downloadUrl" | grep -Po 'downloadUrl" : "\K[^"]*'`
  echo "Nexus download URL for Core WAAP changelog: $downloadUrl"
  rm info.json
  if [ -z "$classifier" ]
  then
    wget -O $artifactId-$version.$type $downloadUrl
  else
    wget -O $artifactId-$version-$classifier.$type $downloadUrl
  fi
}

# Remove extra info in CRD description fields from incl. "||" to before "</br>"
# or to before a line with "<table>", potentially stretching across multiple lines.
# LATER: Would in principle be safer to operate on a parsed CRD, but that
#        would require an additional tool or tools.
removeExtraCrdInfo() {
  cat crd/crd-doc-raw.md | awk 'BEGIN { inExtraInfo = 0 }
    {
      i = index($0, "||")
      j = index($0, "<br/>")
      k = index($0, "<table>")
      if (inExtraInfo) {
        if (j) {
          print substr($0, j, length($0))
          inExtraInfo = 0
        } else if (k) {
          print ""
          print $0
          inExtraInfo = 0
        }
      } else {
        if (i) {
          if (j) {
            print substr($0, 1, i-1) substr($0, j, length($0))
          } else {
            inExtraInfo = 1
            print substr($0, 1, i-1)
          }
        } else {
          print $0
        }
      }
    }
  ' > crd/crd-doc.md
}

generateCrdDocumentation() {
  mkdir crd
  cp usp-core-waap-operator/crds/crd-core-waap.yaml crd/
  crdoc  --resources crd --output crd/crd-doc-raw.md
  removeExtraCrdInfo
}

checkbin mkdocs
checkbin helm
checkbin wget
checkbin crdoc

if [ "$#" -lt 1 ]
then
  echo "Not enough arguments supplied. Usage:"
  echo ""
  echo "./release.sh <helm-chart-version, e.g. 1.0.0> [deploy]"
  echo ""
  echo "If the optional 'deploy' argument is set, the website will be deployed to Github and made public!"
  echo ""
  echo "Example for creating the website without deployment:"
  echo ""
  echo "./release.sh 1.0.0"
  exit 1
fi

# 1st input parameter = Helm Chart version
export CHARTS_VERSION=$1

DIR=`pwd`
rm -rf build
rm -rf docs
rm -rf generated
mkdir build
cd build

# Get Helm charts to extract operator and spec lib info
if [[ $CHARTS_VERSION =~ "SNAPSHOT" || $CHARTS_VERSION =~ "-rc" ]]; then
  helm pull oci://devuspregistry.azurecr.io/helm/usp/core/waap/usp-core-waap-operator --version $CHARTS_VERSION
else
  helm pull oci://uspregistry.azurecr.io/helm/usp/core/waap/usp-core-waap-operator --version $CHARTS_VERSION
fi
tar xzf usp-core-waap-operator-$CHARTS_VERSION.tgz
export OPERATOR_VERSION=`grep 'Operator version:' usp-core-waap-operator/crds/crd-core-waap.yaml | cut -d ':' -f 2 | tr -d ' '`
export SPEC_LIB_VERSION=`grep 'Spec lib version:' usp-core-waap-operator/crds/crd-core-waap.yaml | cut -d ':' -f 2 | tr -d ' '`
export CORE_WAAP_VERSION=`cat usp-core-waap-operator/values.yaml | yq '.operator.config.waapSpecDefaults.version'`

# Perform quick check here - we NEVER want a snapshot documented on the website, so make
# sure that the Helm chart contains a reference to a fixed operator release
if [[ $OPERATOR_VERSION =~ "SNAPSHOT" && "$2" == "deploy" ]]; then
  echo "ERROR: Helm chart contains reference to SNAPSHOT operator: $OPERATOR_VERSION"
  exit 1;
fi

echo "-------------------------------------------------------------"
echo "Selected Helm chart release:       $CHARTS_VERSION"
echo "- Operator release in Helm chart:  $OPERATOR_VERSION"
echo "- Spec lib release in Helm chart:  $SPEC_LIB_VERSION"
echo "- Core WAAP release in Helm chart: $CORE_WAAP_VERSION"
echo "-------------------------------------------------------------"

downloadFromNexus $CORE_WAAP_VERSION ch.u-s-p.core.waap waap md changelog
downloadFromNexus $OPERATOR_VERSION ch.u-s-p.core.waap waap-operator md changelog
downloadFromNexus $CHARTS_VERSION ch.u-s-p.core.waap waap-operator-helm md changelog

# Generate CRD documentation
generateCrdDocumentation

# Download autolearning tool
downloadFromNexus $SPEC_LIB_VERSION ch.u-s-p.core.waap waap-lib-autolearn-cli jar


# TO CHECK ---------------->>>>>>>>>>>>>>>> REALLY GET DEMO APPS FROM CI PROJECT? TBD
# clone ci project and checkout tag matching the helm charts release
git clone git@git.u-s-p.local:core-waap/core-waap-ci.git
cd core-waap-ci
################ git checkout --quiet helm$CHARTS_VERSION
cd ..

# =====================================================================
# Begin site build
# =====================================================================

# Prepare site source directory
cd $DIR

# Copy base markdown files from sources
cp -R src/docs ./docs
cp build/crd/crd-doc.md ./docs/

# Generate autolearn-cli tool doc by capturing the help output into a file
export JARFILE=./build/waap-lib-autolearn-cli-$SPEC_LIB_VERSION.jar

java -jar ./build/waap-lib-autolearn-cli-$SPEC_LIB_VERSION.jar --help > ./build/autolearning-output.log
echo "\`\`\`"  >> ./docs/autolearning.md
cat ./build/autolearning-output.log >> ./docs/autolearning.md
echo "\`\`\`"  >> ./docs/autolearning.md
echo " "  >> ./docs/autolearning.md
echo "[downloaded here]: /downloads/" >> ./docs/autolearning.md

# Generate values documentation Markdown file
helm-docs --chart-search-root=build/usp-core-waap-operator -o helm-values.md


prepareChangelog build/waap-$CORE_WAAP_VERSION-changelog.md ./docs/waap-CHANGELOG.md
prepareChangelog build/waap-operator-$OPERATOR_VERSION-changelog.md ./docs/operator-CHANGELOG.md
prepareChangelog build/waap-operator-helm-$CHARTS_VERSION-changelog.md ./docs/helm-CHANGELOG.md


mkdir -p ./docs/files
######cp build/usp-core-waap-operator/values.yaml docs/files/
cp build/waap-lib-autolearn-cli-$SPEC_LIB_VERSION.jar docs/files/
cp build/usp-core-waap-operator/helm-values.md docs/


# Replace version placeholders in all markdown files
for file in ./docs/*; do
    if [ -f "$file" ]; then
        sed -i -e 's/%RELEASE%/'$OPERATOR_VERSION'/g' $file
        sed -i -e 's/%SPEC_LIB_VERSION%/'$SPEC_LIB_VERSION'/g' $file
        sed -i -e 's/%CHARTS_VERSION%/'$CHARTS_VERSION'/g' $file
        sed -i -e 's/%CORE_WAAP_VERSION%/'$CORE_WAAP_VERSION'/g' $file
    fi
done

# Prepare file downloads
zip -q -r docs/files/juiceshop.zip build/core-waap-ci/demo/juiceshop
zip -q -r docs/files/httpbin.zip build/core-waap-ci/demo/httpbin

echo "Successfully generated site (Markdown) at ./docs."

if [ "$2" == "deploy" ]; then
    echo "Deploying to GitHub pages..."
    mkdocs gh-deploy
    echo "Successfully deployed to to GitHub pages"
fi

trap - ERR
