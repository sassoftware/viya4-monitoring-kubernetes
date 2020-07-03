# Azure Kubelet ServiceMonitor Fix

Azure uses http for kubelet metrics by default. The Prometheus Operator
helm chart defaults to https metrics scraping for the kubelet ServiceMonitor.

See issue: [https://github.com/coreos/prometheus-operator/issues/926](https://github.com/coreos/prometheus-operator/issues/926)

## Use

Add the content from the `user-values-prom-operator.yaml` in this directory
to your `monitoring/user-values-prom-operator.yaml` (under `$USER_DIR if
you have set a custom path set).
