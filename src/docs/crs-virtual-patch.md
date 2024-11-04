# Virtual Patch

The Virtual Patch feature of Core WAAP works in conjunction with [OWASP Core Rule Set](https://coreruleset.org/) (CRS) feature. It provides a possibility to add a custom rule to standard CRS rules. This will allow any vulnerabilities to be immediately patched without waiting for the CRS rules to be updated.

## Configuration

The custom rules configuration section is located in CRS-related part of the configuration:

```yaml
spec:
  crs:
    customRequestBlockingRules:
      - name: "Custom rule 1"
        secLangExpression: >-
          SecRule ARGS_GET:attack "custom-pattern"
          "id:300001,
          ...
      - name: "Custom rule 2"
        secLangExpression: ...
        ...
```

It's a list of rule definitions, each consisting of a name (used for identification purposes only) and a rule expression.

There are not many restrictions imposed on the expression itself (aside from it being a valid [SecLang expression](https://coraza.io/docs/seclang/)). The ID of a rule is a mandatory integer which checked to be in [300000, 399999] interval and unique.

It is advised to use [folded style](https://yaml.org/spec/1.2.2/#813-folded-style) strings with [stripping chomping indicator](https://yaml.org/spec/1.2.2/#8112-block-chomping-indicator) (i.e. >-) and no extra indentation or trailing slashes.

Custom request rules will be inserted just before REQUEST-949-BLOCKING-EVALUATION.conf include, meaning that standard CRS variables (e.g. tx.anomaly_score_pl1) might be used.

Keep in mind though, that by default the BLOCK/DETECT mode specified in '.spec.crs.mode' is not respected by the custom rules. Unless you specifically follow the standard CRS rules' approach of reporting an anomaly (updating corresponding variables, etc.) In order to emulate the DETECT mode, you could just replace [deny](https://coraza.io/docs/seclang/actions/#deny) action with [log](https://coraza.io/docs/seclang/actions/#log) action.

Below is the sample rule that denies the request with 403 if the query string parameter 'attack' has the 'custom-pattern' value.

```yaml
spec:
...
  crs:
    ...
    customRequestBlockingRules:
      - name: "Custom rule"
        secLangExpression: >-
          SecRule ARGS_GET:attack "custom-pattern"
          "id:300001,
          phase:2,deny,status:403,log,
          t:lowercase,t:removeWhitespace,t:htmlEntityDecode,
          msg:'Custom rule message',
          logdata:'Matched Data: custom-pattern found within %{MATCHED_VAR_NAME}: %{MATCHED_VAR}',
          tag:'attack-custom',
          severity:'CRITICAL'"
```
