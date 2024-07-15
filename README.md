# USP Core WAAP

Welcome to the USP Core WAAP (Web Application and API Protection) customers repository. This repository contains
the scripts required to build the USP Core WAAP website:

* https://united-security-providers.github.io/usp-core-waap/

## Requirements

- `mkdocs` to generate the website and deploy it to GitHub pages.
- `helm` command used for pulling the Helm charts to process the "values.yaml" file.
- `oras` CLI tool to query the OCI Helm repository: https://oras.land/
- `helm-docs` to generate markdown from a values YAML file: https://github.com/norwoodj/helm-docs
- `crdoc` to generate the CRD documentation: https://github.com/fybrik/crdoc


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
pip install mkdocs
pip install pymdown-extensions
pip install mkdocs-material
pip install mkdocs-redirects
```

*NOTE:* You may need to log out and log in again to get the mkdocs executable in your PATH. Check by running

```
mkdocs --version
mkdocs, version 1.5.3 from /home/<myuser>/.local/lib/python3.10/site-packages/mkdocs (Python 3.10)
```

### oras notes

Look up oras setup instructions on the site above, but as a backup, here are the current ones:

```
VERSION="1.1.0"
curl -LO "https://github.com/oras-project/oras/releases/download/v${VERSION}/oras_${VERSION}_linux_amd64.tar.gz"
mkdir -p oras-install/
tar -zxf oras_${VERSION}_*.tar.gz -C oras-install/
sudo mv oras-install/oras /usr/local/bin/
rm -rf oras_${VERSION}_*.tar.gz oras-install/
```

### helm-docs notes

* Download the latest release binary from here: https://github.com/norwoodj/helm-docs/releases
* Make sure to download the "Linux x64/64" tar.gz archive
* Then unpack the archive (`tar xzf <filename>`) and just move the executable to a directory in your PATH, e.g.:

```
sudo mv helm-docs /usr/local/bin
```

### crdoc notes

* Download the latest release binary from here: https://github.com/fybrik/crdoc/releases
* Make sure to download the "Linux x64/64" tar.gz archive
* Then unpack the archive (`tar xzf <filename>`) and just move the executable to a directory in your PATH, e.g.:

```
sudo mv crdoc /usr/local/bin
```


## Generate site

Before running the script which generates the site, you need to log in _once_ manually both with the "oras" and
the "helm" tool. Get the password for user "usp-ci-bob" from the Password Safe (search for "usp-ci-bob").

* PasswordSafe link: ps8://MDpPaERzLTlHYUVlNjRVUUJRVnJjWXZ3

Oras login with:

```
$ oras login uspregistry.azurecr.io
Username: usp-ci-bob
Password: <enter password>
```

Helm login with:

```
$ helm registry login uspregistry.azurecr.io --username usp-ci-bob --password <password>
```

To just generate the site locally, run:

```
$ ./release.sh
```

The site has then been generated within the "build" directory.

## Generate and deploy to GitHub

To generate the site and deploy it to GitHub pages, run:

```
$ ./release.sh deploy
```

## Local testing

Generate the site without deploying it, then run `mkdocs` to serve it locally:

```
$ ./release.sh
$ mkdocs serve
```

This will make it available locally (URL visible in output on the shell).

