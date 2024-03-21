# Downloads

## Operator / Helm Charts

Install the operator via Helm using the Helm charts. The Helm charts are available on the USP OCI repository:

- `oci://uspregistry.azurecr.io/helm/usp/core/waap/usp-core-waap-operator`

To just download the Helm charts (latest release):

```
$ helm pull oci://uspregistry.azurecr.io/helm/usp/core/waap/usp-core-waap-operator
```

To install the latest operator release:

```
$ helm install usp-core-waap-operator oci://uspregistry.azurecr.io/helm/usp/core/waap/usp-core-waap-operator --version %CHARTS_VERSION%
```

To override the operator configuration settings in the `operator-configuration.yaml` Helm template, use a local values
file, e.g. `custom-values.yaml` with the `-f` Helm CLI argument:

```
$ helm install -f custom-values.yaml usp-core-waap-operator oci://uspregistry.azurecr.io/helm/usp/core/waap/usp-core-waap-operator --version %CHARTS_VERSION%
```

You can use `helm template` to just render the templates to the console in order to look at the contents, before 
actually installing the operator:

```
$ helm template -f custom-values.yaml usp-core-waap-operator oci://uspregistry.azurecr.io/helm/usp/core/waap/usp-core-waap-operator --version %CHARTS_VERSION%
```

## Operator Configuration

The operator configuration template contains many settings for the operator itself, and/or the WAAP Envoy deployments.
The template bundled in the Helm charts contains default settings from the bundled `values.yaml` file, which will 
usually have to be overridden for any custom deployments. To override the values, a local values YAML file can be used.

The bundled `values.yaml` file can be downloaded here:

* [values.yaml]


## Demo Apps

- Juiceshop: [juiceshop.zip]
- Httpbin: [httpbin.zip]

## Auto-Learning Tool

- Executable Jar: [waap-lib-spec-cli-%SPEC_VERSION%.jar]


[values.yaml]: files/values.yaml
[juiceshop.zip]: files/juiceshop.zip
[httpbin.zip]: files/httpbin.zip
[waap-lib-spec-cli-%SPEC_VERSION%.jar]: files/waap-lib-spec-cli-%SPEC_VERSION%.jar