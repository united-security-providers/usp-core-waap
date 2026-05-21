# Getting Started

This guide walks you through a minimal end-to-end setup: install the **USP Core WAAP operator** into a Kubernetes
cluster and protect an example backend application — the intentionally vulnerable
[OWASP Juice Shop](https://owasp.org/www-project-juice-shop/) — with a `CoreWaapService` custom resource.

If you prefer a fully prepared, browser-based environment, you can also follow the
[Killercoda Core WAAP scenarios](https://killercoda.com/united-security-providers) instead.

!!! tip

    The steps below use the latest Helm chart version: **%CHARTS_VERSION%**.

## Prerequisites

Before you start, make sure you have:

- A running Kubernetes cluster (e.g. `kind`, `minikube`, or a managed cluster) and `kubectl` configured to access it.
- [Helm 3](https://helm.sh/docs/intro/install/) installed locally.
- Pull credentials for the USP container registry (`uspregistry.azurecr.io`). If you do not yet have one,
  [get in touch with us](https://www.united-security-providers.ch/technology/application-security/web-application-api-protection-waap/#more).

!!! tip

    We recommend using a private registry proxy or pull-through cache that handles authentication with the upstream server and is accessible internally without authentication.
    However, it is also possible to use the provided registry directly with some additional steps as described in the steps below.

## 1. Log in to the USP container registry

The operator image and Helm chart are hosted on a private OCI registry. Log in once with the credentials you received
from USP:

```shell
helm registry login uspregistry.azurecr.io --username <your-username>
```

You will be prompted for the password.

## 2. Create USP Core WAAP operator namespace

The operator will be installed in its own namespace `usp-core-waap-operator`:
```shell
kubectl create namespace usp-core-waap-operator
```

## 3. Create Pull secret for operator installation
To install the operator from our registry, you need to setup a pull secret.

```shell
 kubectl -n usp-core-waap-operator create secret docker-registry uspregistry --docker-server=uspregistry.azurecr.io --docker-username=<your-username> --docker-password=<your-password>
```
For other ways how to create such a secret see [Kubernetes.io - Pull an Image from a Private Registry](https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/)

## 4. Install the USP Core WAAP operator

To use the created pull secret you need to create a local helm values file:

```shell
cat >custom-values.yaml <<EOL
operator:
  imagePullSecretName: uspregistry
EOL
```

Install the operator into its own namespace `usp-core-waap-operator`.

```shell
helm install -f custom-values.yaml usp-core-waap-operator \
  oci://uspregistry.azurecr.io/helm/usp/core/waap/usp-core-waap-operator \
  --version %CHARTS_VERSION% \
  --namespace usp-core-waap-operator
```

Verify the operator pod is running:

```shell
kubectl get pods -n usp-core-waap-operator
```

Expected output (pod name will differ):

```text
NAME                                  READY   STATUS    RESTARTS   AGE
core-waap-operator-744f7c8b8-7kfbs    1/1     Running   0          30s
```

The operator now watches for resources of kind `CoreWaapService`. As soon as such a custom resource is created, the
operator deploys a USP Core WAAP instance that protects the configured backend.

For more options (custom values, namespace layout, upgrades, CRD extraction) see the
[Helm Charts](helm.md) page.

## 5. Deploy the Juice Shop example application

Create a namespace and deploy the Juice Shop in it:

```shell
kubectl create namespace juiceshop
```

```yaml
cat >juiceshop.yaml <<EOL
# juiceshop.yaml
apiVersion: v1
kind: Pod
metadata:
  name: juiceshop
  namespace: juiceshop
  labels:
    app: juiceshop
spec:
  containers:
    - name: juiceshop
      image: bkimminich/juice-shop:latest
      ports:
        - containerPort: 3000
---
apiVersion: v1
kind: Service
metadata:
  name: juiceshop
  namespace: juiceshop
spec:
  selector:
    app: juiceshop
  ports:
    - name: http
      port: 8080
      targetPort: 3000
EOL
```

Apply it and wait until the pod is ready:

```shell
kubectl apply -f juiceshop.yaml
kubectl wait pod/juiceshop -n juiceshop --for=condition=Ready --timeout=300s
```

At this point the Juice Shop is reachable inside the cluster on `juiceshop.juiceshop.svc:8080`, but it is **not yet
protected** by USP Core WAAP.

## 6. Protect the Juice Shop with a `CoreWaapService`

Create a `CoreWaapService` resource that puts USP Core WAAP in front of the Juice Shop service:

```yaml
cat >juiceshop-core-waap.yaml <<EOL
# juiceshop-core-waap.yaml
apiVersion: waap.core.u-s-p.ch/v1alpha1
kind: CoreWaapService
metadata:
  name: juiceshop-usp-core-waap
  namespace: juiceshop
spec:
  coraza:
    crs:
      paranoiaLevel: 2
      requestRuleExceptions:
        - location: /rest/basket/.+/checkout$
          regEx: true
          requestPartName: json.couponData
          requestPartType: ARGS_POST
          ruleIds:
            - 942120
  websocket: true
  routes:
    - match:
        path: "/"
        pathType: "PREFIX"
      backend:
        address: juiceshop
        port: 8080
        protocol:
          selection: h1
EOL
```

!!! note

    This example raises the default [Paranoia Level](https://coreruleset.org/docs/2-how-crs-works/2-2-paranoia_levels/)
    from 1 to 2 and adds a
    [requestRuleException](crd-doc.md#corewaapservicespeccrsrequestruleexceptionsindex) so legitimate basket checkouts
    are not blocked as false positives.

Before we can apply the `CoreWaapService` resource, we need to ensure that the used service account can pull the container image.
Therefore we create a pull secret in the `juiceshop` namespace and patch the `default` service account to use it:
```shell
 kubectl -n juiceshop create secret docker-registry uspregistry --docker-server=uspregistry.azurecr.io --docker-username=<your-username> --docker-password=<your-password>
```
```shell
kubectl patch serviceaccount default -n juiceshop --type=json \
  -p='[{"op": "add", "path": "/imagePullSecrets/-", "value": {"name": "uspregistry"}}]'
```

Apply the resource and wait for the proxy pod to come up:

```shell
kubectl apply -f juiceshop-core-waap.yaml

kubectl wait pods \
  -l app.kubernetes.io/name=usp-core-waap-proxy \
  -n juiceshop \
  --for=condition=Ready --timeout=300s
```

Verify the resources are in place:

```shell
kubectl get corewaapservices -n juiceshop
kubectl get pods -l app.kubernetes.io/name=usp-core-waap-proxy -n juiceshop
```

## 7. Verify the protection

Port-forward to the Core WAAP proxy and send a request that triggers an SQL-injection rule:

```shell
kubectl port-forward -n juiceshop svc/juiceshop-usp-core-waap 8080:8080
```

Open a browser and visit `http://localhost:8080` and you should see the OWASP Juice Shop.

To verify if 
```shell
curl -i -X POST http://localhost:8080/rest/user/login \
  -H 'Origin: http://localhost:8080' \
  -H 'Content-Type: application/json' \
  -d '{"email":"%27 OR true;","password":"fail"}'
```

USP Core WAAP rejects the request with `HTTP/1.1 403 Forbidden`. You can inspect the matching CRS rule in the proxy
logs:

```shell
kubectl logs -f \
  -l app.kubernetes.io/name=usp-core-waap-proxy \
  -n juiceshop \
  | grep APPLICATION-ATTACK-SQLI
```

## Next steps

- Explore the full [API reference](crd-doc.md) for `CoreWaapService`.
- Start tuning [Coraza CRS integration](coraza-crs.md)
- Configure additional protections such as [header filtering](header-filtering.md),
  [OpenAPI validation](openapi-validation.md), or [rate limiting](rate-limiting.md).
- Learn about [logs and metrics](logs-metrics.md) for day-2 operations.
- Try the hands-on [Killercoda scenarios](https://killercoda.com/united-security-providers) for guided exercises.
