# Debugging

This chapter describes the recommended approach for debugging crashes, segmentation faults and other issues you might encounter.

!!! tip

    A core dump file can get very big depending on how long Envoy was running. Make sure that you have at least 10G of disk space available to the Core Waap container.

!!! warning

    The debugging image should **never** be used in production.

## Segmentation faults

When a segmentation fault occurs, the first thing to do is to check the logs and the backtrace.
In many cases, these already contain enough information to understand what went wrong and where the crash happened.

If the logs and backtrace are not sufficient, the next step is to switch to the debug version.
The debug version contains debug symbols, which make stack traces and crash analysis more useful.
To switch to the debug version, you need to make the follwing changes:

1. Add the "-debug" suffix to the used Core WAAP version in `CoreWaapService.spec.operation.version`.
   For example if you are using version `1.4.1` then the debug version is `1.4.1-debug`.
2. Optionally, if you also want to enable generating core dumps then you need to update the security context (`CoreWaapService.spec.operation.securityContext`) and add the `SYS_PTRACE` capability.

## Core dumps

*This assumes that you are using the debug version and have added the `SYS_PTRACE` capability as described above.*

A core dump is generated whenever Envoy crashes. You can find the generated file at `/coredumps/envoy.<UNIX_TIMESTAMP>`. After the core dump has been written, Envoy is restarted automatically.

You can either analyze the core dump file directly in the container using:

```bash
kubectl exec -it -n NAMESPACE CORE_WAAP_POD envoy -- bash
lldb-20 /usr/local/bin/envoy -c /coredumps/CORE_DUMP_FILE
```

or you can copy it locally and analyze it outside of kubernetes:

```bash
kubectl cp NAMESPACE/CORE_WAAP_POD:/coredumps/CORE_DUMP_FILE CORE_DUMP_FILE -c envoy
```
