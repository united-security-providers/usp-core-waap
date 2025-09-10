# USP Core WAAP

Welcome to the USP Core WAAP (Web Application and API Protection) customers repository.
This repository contains the scripts required to build the USP Core WAAP website:

**https://docs.united-security-providers.ch/usp-core-waap/latest/**

## Requirements

- `mkdocs` to generate the website and deploy it to GitHub pages.
- `helm` command used for pulling the Helm charts to process the "values.yaml" file.
- `helm-docs` to generate markdown from a values YAML file: https://github.com/norwoodj/helm-docs
- `crdoc` to generate the CRD documentation: https://github.com/fybrik/crdoc
- `yq` to query values from yaml files: https://mikefarah.gitbook.io/yq


### mkdocs notes

* Do NOT install mkdocs as a system package (e.g. Debian package). Those are often older releases. Install
it with the Python package manager "pip" instead. Also, install all the required Python packages as well.

* mkdocs installation guide: https://www.mkdocs.org/user-guide/installation/#installing-mkdocs

#### Install / upgrade pip

```
python get-pip.py
pip install --upgrade pip
```

#### Install mkdocs

```
pip install mkdocs pymdown-extensions mkdocs-material mkdocs-redirects mkdocs-swagger-ui-tag mike
```

*NOTE:* You may need to log out and log in again to get the mkdocs executable in your PATH. Check by running

```
mkdocs --version
mkdocs, version 1.5.3 from /home/<myuser>/.local/lib/python3.10/site-packages/mkdocs (Python 3.10)
```

### helm-docs notes

* Download the latest release binary from here: https://github.com/norwoodj/helm-docs/releases
* Make sure to download the "Linux x86/64" tar.gz archive
* Then unpack the archive (`tar xzf <filename>`) and just move the executable to a directory in your PATH, e.g.:

```
sudo mv helm-docs /usr/local/bin
```

### crdoc notes

* Download the latest release binary from here: https://github.com/fybrik/crdoc/releases
* Make sure to download the "linux_amd64" tar.gz archive
* Then unpack the archive (`tar xzf <filename>`) and just move the executable to a directory in your PATH, e.g.:

```
sudo mv crdoc /usr/local/bin
```

### yq notes

* Download the latest release binary from here: https://github.com/mikefarah/yq/releases/latest
* Make sure to download the "Linux amd64" tar.gz archive
* Then unpack the archive (`tar xzf <filename>`) and just move the executable to a directory in your PATH, e.g.:

```
sudo mv yq_linux_amd64 /usr/local/bin/yq
```

(ast: I installed it via snap instead.)

## Generate site locally

Before running the script which generates the site, you need to log in _once_ manually with
the "helm" tool. Get the password for user "usp-ci-bob" from the Password Safe (search for "usp-ci-bob").

* PasswordSafe link: ps8://MDpPaERzLTlHYUVlNjRVUUJRVnJjWXZ3

Helm login with:

```
$ helm registry login uspregistry.azurecr.io --username usp-ci-bob --password <password>
```

and/or for snapshots and RCs:

```
$ helm registry login devuspregistry.azurecr.io --username usp-ci-bob --password <dev-password>
```

To just generate the site locally, run:

```
$ ./release.sh <helm-version>
```

***TODO*** For releases is clear what to indicate and works, but support of snapshots seems to be only partial (e.g. giving `0.0.0-main-SNAPSHOT` as {helm-version} produced at least when I tried an outdated version of the operator changelog).

The site has then been generated within the "build" directory (Markdown source for mkdocs, not yet HTML).

## Test site locally

Generate the site locally as described above, then run `mkdocs` to serve it locally:

```
$ ./release.sh <helm-version>
$ mkdocs serve
```

This will make it available locally (URL visible in output on the shell, typically http://127.0.0.1:8000/).

## Generate site and publish it via GitHub

To generate the site and deploy it to GitHub pages, run:

```
$ ./release.sh <helm-version> deploy
```

The published page should then become available after a few minutes at the link on top of this page.
