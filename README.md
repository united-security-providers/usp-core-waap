# USP Core WAAP

Welcome to the USP Core WAAP (Web Application and API Protection) customers repository.

## Requirements

- `mkdocs` to generate the website and deploy it to GitHub pages.
- `helm` command used for pulling the Helm charts to process the "values.yaml" file.
- `oras` CLI tool to query the OCI Helm repository: https://oras.land/
- `helm-docs` to generate markdown from a values YAML file: https://github.com/norwoodj/helm-docs

Look up oras setup instructions on the site above, but as a backup, here are the current ones:

```
VERSION="1.1.0"
curl -LO "https://github.com/oras-project/oras/releases/download/v${VERSION}/oras_${VERSION}_linux_amd64.tar.gz"
mkdir -p oras-install/
tar -zxf oras_${VERSION}_*.tar.gz -C oras-install/
sudo mv oras-install/oras /usr/local/bin/
rm -rf oras_${VERSION}_*.tar.gz oras-install/
```

## Generate site

Get the password for "usp-ci-bob" from the Password Safe (search for "usp-ci-bob").

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

To just generate the site, run:

```
$ ./release.sh
```

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

