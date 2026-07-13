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

## Usage

The tool itself is an executable Java archive (jar) and can be [downloaded here](downloads.md).

Run with `java -jar waap-lib-autolearn-cli-%OPERATOR_VERSION%.jar --help` to see usage:
