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

getNexusOutfile() {
  local version=$1
  local groupId=$2
  local artifactId=$3
  local type=$4
  local classifier=$5

  if [ -z "$classifier" ]; then
    echo "$artifactId-$version.$type"
  else
    echo "$artifactId-$version-$classifier.$type"
  fi
}

downloadFromNexus() {
  local version=$1
  local groupId=$2
  local artifactId=$3
  local type=$4
  local classifier=$5
  local outfile
  outfile=$(getNexusOutfile $@)

  local query="http://nexus-bob.u-s-p.local/service/rest/v1/search/assets?sort=version&maven.baseVersion=$version&maven.groupId=$groupId&maven.artifactId=$artifactId&maven.extension=$type&maven.classifier=$classifier"
  echo "Nexus query URL: $query"

  wget -O info.json $query
  downloadUrl=`cat info.json | grep -v '\-sources' | grep -a -m 1 -h "downloadUrl" | grep -Po 'downloadUrl" : "\K[^"]*'`
  echo "Nexus download URL: $downloadUrl"
  rm info.json
  wget -O $outfile $downloadUrl
}

getGitLabOutfile() {
  local version=$1
  local repoPath=$2
  local repoName=$3
  local file=$4
  echo "$repoName-$version-$file"
}

downloadFromGitLab() {
  local version=$1
  local repoPath=$2
  local repoName=$3
  local file=$4
  local outfile
  outfile=$(getGitLabOutfile $@)

  git clone git@git.u-s-p.local:$repoPath/$repoName.git
  (cd ${repoName} && git checkout --quiet $version)
  cp $repoName/$file $outfile
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
export EXT_PROC_ICAP_VERSION=`cat usp-core-waap-operator/values.yaml | yq '.operator.config.waapSpecTrafficProcessingDefaults.icap.version'`
export EXT_PROC_OPENAPI_VERSION=`cat usp-core-waap-operator/values.yaml | yq '.operator.config.waapSpecTrafficProcessingDefaults.openapi.version'`

# Perform quick check here - we NEVER want a snapshot documented on the website, so make
# sure that the Helm chart contains a reference to a fixed operator release
if [[ $OPERATOR_VERSION =~ "SNAPSHOT" && "$2" == "deploy" ]]; then
  echo "ERROR: Helm chart contains reference to SNAPSHOT operator: $OPERATOR_VERSION"
  exit 1;
fi

echo "-------------------------------------------------------------"
echo "Selected Helm chart release:             $CHARTS_VERSION"
echo "- Operator release in Helm chart:        $OPERATOR_VERSION"
echo "- Spec lib release in Helm chart:        $SPEC_LIB_VERSION"
echo "- Core WAAP release in Helm chart:       $CORE_WAAP_VERSION"
echo "- extProc ICAP release in Helm chart:    $EXT_PROC_ICAP_VERSION"
echo "- extProc OpenAPI release in Helm chart: $EXT_PROC_OPENAPI_VERSION"
echo "-------------------------------------------------------------"

# Get changelogs from Nexus or GitLab

ARGS="$CHARTS_VERSION ch.u-s-p.core.waap waap-operator-helm md changelog"
downloadFromNexus $ARGS
CHARTS_CHANGELOG=$(getNexusOutfile $ARGS)

ARGS="$OPERATOR_VERSION ch.u-s-p.core.waap waap-operator md changelog"
downloadFromNexus $ARGS
OPERATOR_CHANGELOG=$(getNexusOutfile $ARGS)

ARGS="v$CORE_WAAP_VERSION core-waap core-waap-build CHANGELOG.md"
downloadFromGitLab $ARGS
CORE_WAAP_CHANGELOG=$(getGitLabOutfile $ARGS)

ARGS="$EXT_PROC_ICAP_VERSION core-waap/ext-proc core-waap-ext-proc-icap CHANGELOG.md"
downloadFromGitLab $ARGS
EXT_PROC_ICAP_CHANGELOG=$(getGitLabOutfile $ARGS)

ARGS="$EXT_PROC_OPENAPI_VERSION core-waap/ext-proc core-waap-ext-proc-openapi CHANGELOG.md"
downloadFromGitLab $ARGS
EXT_PROC_OPENAPI_CHANGELOG=$(getGitLabOutfile $ARGS)

# Generate CRD documentation
generateCrdDocumentation

# Download autolearning tool
ARGS="$SPEC_LIB_VERSION ch.u-s-p.core.waap waap-lib-autolearn-cli jar"
downloadFromNexus $ARGS
AUTOLEARN_CLI_JAR=$(getNexusOutfile $ARGS)

# TO CHECK ---------------->>>>>>>>>>>>>>>> REALLY GET DEMO APPS FROM CI PROJECT? TBD
# clone ci project
git clone git@git.u-s-p.local:core-waap/core-waap-ci.git
# checkout tag matching the helm charts release
#(cd core-waap-ci && git checkout --quiet helm$CHARTS_VERSION)

# =====================================================================
# Begin site build
# =====================================================================

# Prepare site source directory
cd $DIR

# Copy base markdown files from sources
cp -R src/docs docs
cp build/crd/crd-doc.md docs/

# Generate autolearn-cli tool doc by capturing the help output into a file
java -jar build/$AUTOLEARN_CLI_JAR --help > build/autolearning-output.log
echo "\`\`\`"  >> docs/autolearning.md
cat build/autolearning-output.log >> docs/autolearning.md
echo "\`\`\`"  >> docs/autolearning.md
echo " "  >> docs/autolearning.md
echo "[downloaded here]: /downloads/" >> docs/autolearning.md

# Generate values documentation Markdown file
helm-docs --chart-search-root=build/usp-core-waap-operator -o helm-values.md

prepareChangelog build/$CHARTS_CHANGELOG docs/helm-CHANGELOG.md
prepareChangelog build/$OPERATOR_CHANGELOG docs/operator-CHANGELOG.md
prepareChangelog build/$CORE_WAAP_CHANGELOG docs/waap-CHANGELOG.md
prepareChangelog build/$EXT_PROC_ICAP_CHANGELOG docs/ext-proc-icap-CHANGELOG.md
prepareChangelog build/$EXT_PROC_OPENAPI_CHANGELOG docs/ext-proc-openapi-CHANGELOG.md

mkdir -p docs/files
######cp build/usp-core-waap-operator/values.yaml docs/files/
cp build/$AUTOLEARN_CLI_JAR docs/files/
cp build/usp-core-waap-operator/helm-values.md docs/

# Replace version placeholders in all markdown files
for file in docs/*; do
    if [ -f "$file" ]; then
        sed -i -e 's/%RELEASE%/'$OPERATOR_VERSION'/g' $file
        sed -i -e 's/%SPEC_LIB_VERSION%/'$SPEC_LIB_VERSION'/g' $file
        sed -i -e 's/%CHARTS_VERSION%/'$CHARTS_VERSION'/g' $file
        sed -i -e 's/%CORE_WAAP_VERSION%/'$CORE_WAAP_VERSION'/g' $file
        sed -i -e 's/%EXT_PROC_ICAP_VERSION%/'$EXT_PROC_ICAP_VERSION'/g' $file
        sed -i -e 's/%EXT_PROC_OPENAPI_VERSION%/'$EXT_PROC_OPENAPI_VERSION'/g' $file
    fi
done

# Prepare file downloads
zip -q -r docs/files/juiceshop.zip build/core-waap-ci/demo/juiceshop
zip -q -r docs/files/httpbin.zip build/core-waap-ci/demo/httpbin

echo "Successfully generated site (Markdown) at docs."

if [ "$2" == "deploy" ]; then
    echo "Deploying to GitHub pages..."
    mkdocs gh-deploy
    echo "Successfully deployed to to GitHub pages"
fi

trap - ERR
