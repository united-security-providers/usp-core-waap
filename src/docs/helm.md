# Helm Charts

Install the operator via Helm using the Helm charts. The Helm charts are available on the USP OCI repository:

- `oci://uspregistry.azurecr.io/helm/usp/core/waap/usp-core-waap-operator`

## Download (pull)

To just download the Helm charts (latest release):

```
helm pull oci://uspregistry.azurecr.io/helm/usp/core/waap/usp-core-waap-operator
```

## Install operator

To install the latest operator release (into existing default namespace) use:

```
helm install usp-core-waap-operator oci://uspregistry.azurecr.io/helm/usp/core/waap/usp-core-waap-operator --version %CHARTS_VERSION%
```

To install the operator into a custom namespace called `usp-core-waap-op` use:

```
helm install --create-namespace --namespace usp-core-waap-operator usp-core-waap-operator oci://uspregistry.azurecr.io/helm/usp/core/waap/usp-core-waap-operator --version %CHARTS_VERSION%
```

**Note:** The `--create-namespace` is required if the namespace does not yet exist but can be also be used if the namespace already exists (helm will then skip namespace creation). Detailed information about `--create-namespace` and `--namespace` options are available via [helm documentation](https://helm.sh/docs/helm/helm_install/).


To override the operator configuration settings in the `operator-configuration.yaml` Helm template, use a local values
file, e.g. `custom-values.yaml` with the `-f` Helm CLI argument:

```
helm install -f custom-values.yaml usp-core-waap-operator oci://uspregistry.azurecr.io/helm/usp/core/waap/usp-core-waap-operator --version %CHARTS_VERSION%
```

## Extract Operator Custom Resource Definition (CRD)

In order to extract the CRD (Custom Resource Definition) you can use:

```
helm show crds oci://uspregistry.azurecr.io/helm/usp/core/waap/usp-core-waap-operator --version %CHARTS_VERSION% > usp-core-waap-crd-%CHARTS_VERSION%.yaml
```

**Note:** If you upgrade the operator **you manually have to apply the new CRD definition** prior to the helm upgrade command!

## Upgrade operator

As [documented by helm](https://helm.sh/docs/chart_best_practices/custom_resource_definitions/) version 3 of helm does not yet support CRD upgrades and as such the will be skipped during a `helm upgrade` command with a warning, which can be prevented using the `--skip-crds` flag.

In order to upgrade the current installed CRD **you manually have to upgrade it** otherwise the upgrade will not be successful!

1. extract CRD: `helm show crds oci://uspregistry.azurecr.io/helm/usp/core/waap/usp-core-waap-operator --version %CHARTS_VERSION% > usp-core-waap-crd-%CHARTS_VERSION%.yaml`
1. [manually apply](https://kubernetes.io/docs/reference/using-api/server-side-apply/) new CRD: `kubectl apply --server-side -f usp-core-waap-crd-%CHARTS_VERSION%.yaml --force-conflicts`
1. upgrade operator: `helm upgrade --namespace <operator-namespace> <release-name> oci://uspregistry.azurecr.io/helm/usp/core/waap/usp-core-waap-operator --version %CHARTS_VERSION%`

**Note:** This generic procedure does not take into account possible **manual changes to be applied prior to the operator `helm upgrade` command** as support for automatic migration is not yet provided.

## Information

You can use `helm template` to just render the templates to the console in order to look at the contents, before 
actually installing the operator:

```
helm template -f custom-values.yaml usp-core-waap-operator oci://uspregistry.azurecr.io/helm/usp/core/waap/usp-core-waap-operator --version %CHARTS_VERSION%
```