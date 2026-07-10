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
* `metadata.creationTimestamp`, `metadata.generation`, `metadata.selfLink`:
  These would generally do not harm but there is also no reason to send them back.
* `status`
* `metadata.annotations."kubectl.kubernetes.io/last-applied-configuration"`:
  This is kubectl's private state for its 3-way merge; playing back a stale copy
 can make a later `kubectl apply` compute the wrong diff (e.g., wrongly pruning fields). If the user re-applies with kubectl, kubectl will regenerate it anyway.

Everything else in `metadata` is left untouched.
That includes name, namespace, labels, finalizers, and third-party annotations
like the ArgoCD tracking-id. Stripping the ArgoCD annotation would actually be
worse than keeping it, and keeping it is harmless, since ArgoCD rewrites it on
sync anyway.

Note also that edits by tje Autolearning CLI in the spec part are "surgical"
in the sense that they only add/modify what was learned, but do not turn
implicit defaults into explicit settings (like older versions first did).

## Data Sources

Log file and CR/spec can be read from local files or be obtained on-the-fly
from Kubernetes (including one of these two locally and the other from Kubernetes);
see the corresponding parameters in the usage shown a bit further below.

## Usage

The tool itself is an executable Java archive (jar) and can be [downloaded here](downloads.md).

Run with `java -jar waap-lib-autolearn-cli-%OPERATOR_VERSION%.jar --help` to see usage:
