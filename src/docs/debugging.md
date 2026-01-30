# Debugging

This chapter describes the recommended approach for debugging crashes, segmentation faults and other issues you might encounter.

!!! tip

    A core dump file can get very big depending on how long Core WAAP proxy was running. Make sure that you have at least 10G of disk space available to the Core Waap container.

!!! warning

    The debugging image should **never** be used in production. The used binary for Core WAAP proxy was built in debug mode which means it contains zero optimizations. This has a big impact on performance.

## Segmentation faults and core dumps

When a segmentation fault occurs, the first thing to do is to check the logs and the backtrace.
In many cases, these already contain enough information to understand what went wrong and where the crash happened.

If the logs and backtrace are not sufficient, the next step is to switch to the debug version.
The debug version contains debug symbols, which make stack traces and crash analysis more useful.
In addition, a core dump is always generated whenever a crash happens.
You can find the generated file at `/coredumps/envoy.<UNIX_TIMESTAMP>`.
After the core dump has been written, Core WAAP proxy is restarted automatically.

## How to switch to the debug version

1. Open the Core WAAP configuration file or edit it directly in kubernetes with `kubectl edit corewaapservices.waap.core.u-s-p.ch ...`
2. Add the "-debug" suffix to the used version in `CoreWaapService.spec.operation.version`.
   For example if you are using version `2.0.0` then the debug version is `2.0.0-debug`.
   If you don't have a version specified, then you can check the default version with `kubectl get configmaps --namespace OPERATOR_NAMESPACE usp-core-waap-operator-config -ojsonpath='{.data.operator-config\.yaml}'`
3. Add the `SYS_PTRACE` capability to (`CoreWaapService.spec.operation.securityContext`)
4. Apply or save the new configuration

Example:

```diff
apiVersion: waap.core.u-s-p.ch/v1alpha1
kind: CoreWaapService
metadata:
  namespace: backend-httpbin
  name: httpbin-core-waap
spec:
  operation:
-   version: 2.0.0
+   version: 2.0.0-debug
  securityContext:
    allowPrivilegeEscalation: false
    privileged: false
    readOnlyRootFilesystem: true
    runAsGroup: 65533
    runAsNonRoot: true
    runAsUser: 185
+   capabilities:
+     add: ["SYS_PTRACE"]
  routes:
    - backend:
        address: httpbin
        port: 8000
        protocol:
          selection: h1
      match:
        path: /
        pathType: PREFIX
```

Now the Core WAAP operator should recreated the Core WAAP proxy deployment using the debug version.

## Core dump file analysis

The core dump file can either be analyzed directly in the container:

```bash
kubectl exec -it -n NAMESPACE CORE_WAAP_POD envoy -- bash
lldb-20 /usr/local/bin/envoy -c /coredumps/CORE_DUMP_FILE
```

or you can copy it locally and analyze it outside of kubernetes:

```bash
kubectl cp NAMESPACE/CORE_WAAP_POD:/coredumps/CORE_DUMP_FILE CORE_DUMP_FILE -c envoy
```

A segfault can also be forced by sending a `SIGSEGV` signal to the Core WAAP proxy process.
Simply run `kill -11 <CORE_WAAP_PROXY_PID>` in a POD that has enough permissions (e.g. the Core WAAP proxy container).
