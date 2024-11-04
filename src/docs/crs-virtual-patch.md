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

Below is the sample of fix for Log4j CVE-2021-44228 exploit.

```yaml
spec:
...
  crs:
    mode: BLOCK
    customRequestBlockingRules:
    - name: Log4J
      secLangExpression: >-
        SecRule REQUEST_LINE|ARGS|ARGS_NAMES|REQUEST_COOKIES|REQUEST_COOKIES_NAMES|REQUEST_HEADERS|XML://*|XML://@* "@rx (?:\${[^}]{0,4}\${|\${(?:jndi|ctx))" 
        "id:300001,
        phase:2,
        deny,
        t:none,t:urlDecodeUni,t:cmdline,
        log,
        msg:'Potential Remote Command Execution: Log4j CVE-2021-44228',
        logdata:'Matched Data found',
        tag:'application-multi',
        tag:'language-java',
        tag:'platform-multi',
        tag:'attack-rce',
        severity:'CRITICAL'" 
```
