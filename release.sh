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
    echo "HINT: If you are using a python virtual environment then you need to active it before running this script"
    exit
  fi
}

prepareChangelog() {
  local sourceFile=$1
  local targetFile=$2
  local notices=$3

  rm -rf changelog-tmp
  mkdir changelog-tmp

  # Remove all "[...]: ..." link declarations (typ. at the bottom of the file)
  sed -e "s/^\[[^\]*\]: http.*//g" $sourceFile > changelog-tmp/CHANGELOG2.md

  # Remove brackets for internal links [...], but not for links with [...](...)
  sed -E 's|\[([^]]+)]([^(])|\1\2|g' changelog-tmp/CHANGELOG2.md > changelog-tmp/CHANGELOG3.md
  sed -E 's|\[([^]]+)]$|\1|g' changelog-tmp/CHANGELOG3.md > changelog-tmp/CHANGELOG4.md

  # Add notices (if any)
  sed "s|# Changelog|# Changelog$notices|g" changelog-tmp/CHANGELOG4.md > $targetFile

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

  git clone --depth 1 --branch $version git@git.u-s-p.local:$repoPath/$repoName.git
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
checkbin mike
checkbin helm
checkbin wget
checkbin crdoc

if [ "$#" -lt 1 ]
then
  echo "Not enough arguments supplied. Usage:"
  echo ""
  echo "./release.sh <helm-chart-version, e.g. 1.0.0> [deploy] [--latest] "
  echo ""
  echo "If the optional 'deploy' argument is set, the website will be deployed to Github and made public!"
  echo "If the optional 'latest' flag is set, then the specified version will become the latest version"
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
export CORE_WAAP_PROXY_VERSION=`cat usp-core-waap-operator/values.yaml | yq -r '.operator.config.waapSpecDefaults.version'`

# Perform quick check here - we NEVER want a snapshot documented on the website, so make
# sure that the Helm chart contains a reference to a fixed operator release
if [[ $OPERATOR_VERSION =~ "SNAPSHOT" && "$2" == "deploy" ]]; then
  echo "ERROR: Helm chart contains reference to SNAPSHOT operator: $OPERATOR_VERSION"
  exit 1;
fi

echo "-------------------------------------------------------------"
echo "Selected Helm chart release:             $CHARTS_VERSION"
echo "- Operator release in Helm chart:        $OPERATOR_VERSION"
echo "- Core WAAP Proxy release in Helm chart: $CORE_WAAP_PROXY_VERSION"
echo "- extProc ICAP release in Helm chart:    $EXT_PROC_ICAP_VERSION"
echo "- extProc OpenAPI release in Helm chart: $EXT_PROC_OPENAPI_VERSION"
echo "-------------------------------------------------------------"

# Adapt for change of tagged version in https://git.u-s-p.local/core-waap/core-waap-proxy-build/-/tags (up to 1.3.0 "v1.3.0", from 1.4.0 "1.4.0")
if [[ $CHARTS_VERSION =~ ^1.[0-3].* ]]; then
  export CORE_WAAP_PROXY_VERSION="v$CORE_WAAP_PROXY_VERSION"
fi

# Get changelogs from Nexus or GitLab

ARGS="$CHARTS_VERSION ch.u-s-p.core.waap waap-operator-helm md changelog"
downloadFromNexus $ARGS
CHARTS_CHANGELOG=$(getNexusOutfile $ARGS)

ARGS="$OPERATOR_VERSION ch.u-s-p.core.waap waap-operator md changelog"
downloadFromNexus $ARGS
OPERATOR_CHANGELOG=$(getNexusOutfile $ARGS)

ARGS="$CORE_WAAP_PROXY_VERSION core-waap core-waap-proxy-build CHANGELOG.md"
downloadFromGitLab $ARGS
CORE_WAAP_PROXY_CHANGELOG=$(getGitLabOutfile $ARGS)

ARGS="$EXT_PROC_ICAP_VERSION core-waap/ext-proc core-waap-ext-proc-icap CHANGELOG.md"
downloadFromGitLab $ARGS
EXT_PROC_ICAP_CHANGELOG=$(getGitLabOutfile $ARGS)

ARGS="$EXT_PROC_OPENAPI_VERSION core-waap/ext-proc core-waap-ext-proc-openapi CHANGELOG.md"
downloadFromGitLab $ARGS
EXT_PROC_OPENAPI_CHANGELOG=$(getGitLabOutfile $ARGS)

# Generate CRD documentation
generateCrdDocumentation

# Download autolearning tool
ARGS="$OPERATOR_VERSION ch.u-s-p.core.waap waap-lib-autolearn-cli jar"
downloadFromNexus $ARGS
AUTOLEARN_CLI_JAR=$(getNexusOutfile $ARGS)

# TO CHECK ---------------->>>>>>>>>>>>>>>> REALLY GET DEMO APPS FROM CI PROJECT? TBD
# clone ci project
git clone  --depth 1 git@git.u-s-p.local:core-waap/core-waap-ci.git
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

ALPHA_NOTICE="\n\n_This component\/feature is in still active development (\"alpha\"); it is not recommended to already use it in productive environments._"
MIGRATION_NOTICE="\n\nBreaking changes/additions may require to adapt existing configurations when updating, see [Migration Guide](upgrade.md)."
prepareChangelog build/$CHARTS_CHANGELOG docs/helm-CHANGELOG.md "$MIGRATION_NOTICE"
prepareChangelog build/$OPERATOR_CHANGELOG docs/operator-CHANGELOG.md "$MIGRATION_NOTICE"
prepareChangelog build/$CORE_WAAP_PROXY_CHANGELOG docs/waap-proxy-CHANGELOG.md "$MIGRATION_NOTICE"
prepareChangelog build/$EXT_PROC_ICAP_CHANGELOG docs/ext-proc-icap-CHANGELOG.md "$MIGRATION_NOTICE"
prepareChangelog build/$EXT_PROC_OPENAPI_CHANGELOG docs/ext-proc-openapi-CHANGELOG.md "$ALPHA_NOTICE$MIGRATION_NOTICE"

mkdir -p docs/files
######cp build/usp-core-waap-operator/values.yaml docs/files/
cp build/$AUTOLEARN_CLI_JAR docs/files/
cp build/usp-core-waap-operator/helm-values.md docs/

# Replace version placeholders in all markdown files
for file in docs/*; do
    if [ -f "$file" ]; then
        sed -i -e 's/%OPERATOR_VERSION%/'$OPERATOR_VERSION'/g' $file
        sed -i -e 's/%CHARTS_VERSION%/'$CHARTS_VERSION'/g' $file
        sed -i -e 's/%CORE_WAAP_PROXY_VERSION%/'$CORE_WAAP_PROXY_VERSION'/g' $file
        sed -i -e 's/%EXT_PROC_ICAP_VERSION%/'$EXT_PROC_ICAP_VERSION'/g' $file
        sed -i -e 's/%EXT_PROC_OPENAPI_VERSION%/'$EXT_PROC_OPENAPI_VERSION'/g' $file
    fi
done

# Prepare file downloads
zip -q -r docs/files/juiceshop.zip build/core-waap-ci/demo/juiceshop
zip -q -r docs/files/httpbin.zip build/core-waap-ci/demo/httpbin

echo "Successfully generated site (Markdown) in docs folder."

[ "$2" == "deploy" ] && DEPLOY=true && shift
[ "$2" == "--latest" ] && RELEASE_ALIAS=latest && shift

if [ $DEPLOY ]; then
    echo "Deploying to GitHub pages..."
    version=$(echo "$CHARTS_VERSION" | sed -E 's/^v?([0-9]+)\.([0-9]+)\.[0-9]+$/\1.\2.x/')
    mike deploy --update-aliases --push "${version}" $RELEASE_ALIAS
    echo "Successfully deployed to to GitHub pages"
else
    echo "Building website locally in 'generated' subfolder..."
    mkdocs build
    echo "Website generated."
fi

if [[ $DEPLOY && "${RELEASE_ALIAS}" == "latest" ]]; then
    echo "Setting default latest..."
    mike set-default --push --allow-empty "${RELEASE_ALIAS}"
    echo "Set default latest."
fi

trap - ERR
