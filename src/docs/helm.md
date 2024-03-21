# Helm Charts

Install the operator via Helm using the Helm charts. The Helm charts are available on the USP OCI repository:

- `oci://uspregistry.azurecr.io/helm/usp/core/waap/usp-core-waap-operator`

## Download (pull)

To just download the Helm charts (latest release):

```
$ helm pull oci://uspregistry.azurecr.io/helm/usp/core/waap/usp-core-waap-operator
```

## Install operator

To install the latest operator release:

```
$ helm install usp-core-waap-operator oci://uspregistry.azurecr.io/helm/usp/core/waap/usp-core-waap-operator --version %CHARTS_VERSION%
```

To override the operator configuration settings in the `operator-configuration.yaml` Helm template, use a local values
file, e.g. `custom-values.yaml` with the `-f` Helm CLI argument:

```
$ helm install -f custom-values.yaml usp-core-waap-operator oci://uspregistry.azurecr.io/helm/usp/core/waap/usp-core-waap-operator --version %CHARTS_VERSION%
```

## Information

You can use `helm template` to just render the templates to the console in order to look at the contents, before 
actually installing the operator:

```
$ helm template -f custom-values.yaml usp-core-waap-operator oci://uspregistry.azurecr.io/helm/usp/core/waap/usp-core-waap-operator --version %CHARTS_VERSION%
```