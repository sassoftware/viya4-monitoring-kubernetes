# Deployment on Azure

This sample contains values appropriate for deployment on Microsoft Azure.

## Instructions

```bash
export USER_DIR=path/to/my/user-dir
mkdir -p $USER_DIR/monitoring
cp monitoring/samples/azure/deployment/user-values-prom-operator.yaml $USER_DIR/monitoring/
monitoring/bin/deploy_monitoring_cluster.sh
# Deployment takes a bit...then
VIYA_NS=my-viya-namespace-here monitoring/bin/deploy_monitoring_viya.sh
```
