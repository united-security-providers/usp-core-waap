# Auto-Learning

USP Core WAAP provides a command-line tool that allows to update configuration of an existing USP Core WAAP instance
based on the information from its runtime log files.

There are different processing options that can be activated independently:

* `crs`: Learns 'false positives' of the Coraza (ModSecurity/CRS) engine and generates rule exceptions to avoid them.
* `graphql`: Learns maxima for complexity, length and batch size and generates settings to allow them.
* `methods`: Learns allowed HTTP methods for configured routes and generates 'allowedMethods' settings for those routes.

## Handling of the CR/spec

A CR obtained from Kubernetes usually contains some fields that have been
set on the server side and should not be fed back to Kubernetes.
Accordingly, the autolearning tool strips the following from CRs:

* `metadata.resourceVersion`
* `metadata.uid`
* `metadata.managedFields`
* `metadata.creationTimestamp`, `metadata.generation`, `metadata.selfLink`
* `status`
* `metadata.annotations."kubectl.kubernetes.io/last-applied-configuration"`

Everything else in `metadata` is left untouched.

Note also that edits by the Autolearning CLI in the spec part are "surgical"
in the sense that they only add/modify what was learned, but do not turn
implicit defaults into explicit settings (like older versions first did).

## Data Sources

Log file and CR/spec can be read from local files or be obtained on-the-fly
from Kubernetes (including one of these two locally and the other from Kubernetes);
see the corresponding parameters in the usage shown a bit further below.

## Examples

The examples below use a shell variable for the jar name, just to keep the
commands short:

```shell
JAR=waap-lib-autolearn-cli-%OPERATOR_VERSION%.jar
```

A few things that apply to all examples:

* At least one processor (`crs`, `graphql` and/or `methods`) must be given;
  several may be combined in a single run.
* When spec and/or logs are read from Kubernetes (`-n`/`-w`), `kubectl` must be
  installed and configured for the target cluster (the tool simply shells out to
  it using your current context).
* If no output file is given with `-o`, the result is written to `waap.yaml`.

### Learn everything from a running instance (Kubernetes)

The simplest case: read both the CR/spec and the pod logs straight from
Kubernetes and run all three processors, writing the result to `waap.yaml`:

```shell
java -jar $JAR crs graphql methods -n my-namespace -w my-instance
```

Here `-w` is the instance name (the `app.kubernetes.io/instance` label, which is
also the name of the `CoreWaapService` resource).

### Learn from local files

If you prefer to work offline, first grab the spec and logs yourself (this is
exactly what the tool does internally when reading from Kubernetes):

```shell
kubectl -n my-namespace get corewaapservices.waap.core.u-s-p.ch my-instance -o yaml > waap-in.yaml
POD=$(kubectl -n my-namespace get pods --selector=app.kubernetes.io/instance=my-instance -o jsonpath='{.items[0].metadata.name}')
kubectl -n my-namespace logs pods/$POD > waap.log
```

Then learn from the files and write to an output file:

```shell
java -jar $JAR crs -i waap-in.yaml -l waap.log -o waap-out.yaml
```

### Mix sources (spec from Kubernetes, logs from a file)

You can take one input from a file and the other from Kubernetes. Here the spec
comes from Kubernetes (no `-i` given) while the logs are read from a file:

```shell
java -jar $JAR crs -l waap.log -n my-namespace -w my-instance
```

(Giving *both* `-i` and `-l` together with `-n`/`-w` is not allowed, since then
Kubernetes would not be needed at all.)

### Pipe via stdin/stdout

Use `-` to read the spec from stdin and/or write the result to stdout (writing
to stdout also silences the summary output):

```shell
kubectl -n my-namespace get corewaapservices.waap.core.u-s-p.ch my-instance -o yaml \
  | java -jar $JAR crs -i - -l waap.log -o -
```

### Learn a single aspect

Each processor can of course be run on its own. It is recommended to first run
the respective feature in mode `DETECT` (see [CRS](coraza-crs.md) and
[GraphQL](coraza-graphql.md)) and then learn from the resulting logs:

```shell
# CRS rule exceptions (learned from 'coraza-waf' log lines)
java -jar $JAR crs -i waap-in.yaml -l waap.log -o waap-out.yaml

# GraphQL maxima for complexity, depth and batch size
java -jar $JAR graphql -i waap-in.yaml -l waap.log -o waap-out.yaml

# Allowed HTTP methods per route (learned from access log lines)
java -jar $JAR methods -i waap-in.yaml -l waap.log -o waap-out.yaml
```

### Restrict learning to a time range

Learn only from log entries within a given time range
(`yyyyMMdd.HHmm-yyyyMMdd.HHmm`), e.g. a specific test window:

```shell
java -jar $JAR crs -n my-namespace -w my-instance -t 20260319.0900-20260319.1800
```

### Fine-tune CRS output

The CRS processor has a few extra options, e.g. to sort the generated rule
exceptions and to consolidate exceptions that are already configured:

```shell
java -jar $JAR crs -i waap-in.yaml -l waap.log -o waap-out.yaml --sortexceptions --reduceconfigured
```

See the [Usage](#usage) section below for the complete list of options.

## Usage

The tool itself is an executable Java archive (jar) and can be [downloaded here](downloads.md).

Run with `java -jar waap-lib-autolearn-cli-%OPERATOR_VERSION%.jar --help` to see usage:
