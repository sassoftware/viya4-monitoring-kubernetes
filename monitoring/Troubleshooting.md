# Troubleshooting

## Issue: Manually deleting the monitoring namespace does not delete all components 

### Description
The monitoring components should be removed by using the `remove_monitoring_cluster.sh` and 
`remove_monitoring_viya.sh` scripts. See [Remove Monitoring Components](README.md#mremove) for more information. If you attempt to remove the monitoring components by only deleting the namespace into which the components are deployed, components in other locations are not removed and redeployment of monitoring fails. 

### Solution
Run these commands to delete all of the monitoring components that are in locations 
other than the monitoring namespace.

```bash
kubectl delete PodSecurityPolicy v4m-alertmanager v4m-es-psp 
v4m-grafana v4m-grafana-test v4m-kube-state-metrics v4m-node-exporter 
v4m-operator v4m-prometheus

kubectl delete ClusterRole psp-v4m-kube-state-metrics psp-v4m-node-exporter 
v4m-fb v4m-grafana-clusterrole v4m-kube-state-metrics v4m-operator 
v4m-operator-psp v4m-prometheus v4m-prometheus-psp

kubectl delete ClusterRoleBinding psp-v4m-kube-state-metrics 
psp-v4m-node-exporter v4m-fb v4m-grafana-clusterrolebinding 
v4m-kube-state-metrics v4m-operator v4m-operator-psp v4m-prometheus 
v4m-prometheus-psp

kubectl delete Service v4m-coredns v4m-kube-controller-manager 
v4m-kube-etcd v4m-kube-proxy v4m-kube-scheduler 
v4m-kubelet -n kube-system

kubectl delete MutatingWebhookConfiguration v4m-admission

kubectl delete ValidatingWebhookConfiguration v4m-admission
```