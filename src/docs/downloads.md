# Downloads

## Helm Charts

- Operator: Install or pull from USP Helm charts OCI repository
- Repository: `oci://uspregistry.azurecr.io/helm/usp/core/waap/usp-core-waap-operator`

Install current operator release:

```
$ helm install usp-core-waap-operator oci://uspregistry.azurecr.io/helm/usp/core/waap/usp-core-waap-operator --version %RELEASE%
```

To override the operator configuration settings in the `operator-configuration.yaml` Helm template, use a local values
file, e.g. `custom-values.yaml` with the `-f` Helm CLI argument:

```
$ helm install -f custom-values.yaml usp-core-waap-operator oci://uspregistry.azurecr.io/helm/usp/core/waap/usp-core-waap-operator --version %RELEASE%
```

You can use `helm template` to just render the templates to the console in order to look at the contents, before 
actually installing the operator:

```
$ helm template -f custom-values.yaml usp-core-waap-operator oci://uspregistry.azurecr.io/helm/usp/core/waap/usp-core-waap-operator --version %RELEASE%
```


## Demo Apps

- Juiceshop: [juiceshop.zip]
- Httpbin: [httpbin.zip]

## Auto-Learning Tool

- Executable Jar: [waap-lib-spec-cli-%SPEC_VERSION%.jar]



[usp-core-waap-operator-%RELEASE%.zip]: files/usp-core-waap-operator-%RELEASE%.zip
[juiceshop.zip]: files/juiceshop.zip
[httpbin.zip]: files/httpbin.zip
[waap-lib-spec-cli-%SPEC_VERSION%.jar]: files/waap-lib-spec-cli-%SPEC_VERSION%.jar