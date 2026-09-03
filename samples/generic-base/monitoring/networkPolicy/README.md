# User-Provided NetworkPolicies

Kube State Metrics (KSM) and Node Exporter are each protected by a default
`NetworkPolicy` that restricts ingress to Prometheus pods only. You can use
the `$USER_DIR/monitoring/networkPolicy` directory to supply your own
replacement for either of these:

* `$USER_DIR/monitoring/networkPolicy/kube-state-metrics.yaml` overrides the
  default NetworkPolicy for Kube State Metrics.
* `$USER_DIR/monitoring/networkPolicy/node-exporter.yaml` overrides the
  default NetworkPolicy for Node Exporter.

This is only needed if you require custom ingress rules, or if you already
manage a `NetworkPolicy` of your own with the same name in the monitoring
namespace. See the [NetworkPolicy](https://kubernetes.io/docs/concepts/services-networking/network-policies/)
documentation for details on defining a `NetworkPolicy` resource.

Note: because Node Exporter runs with `hostNetwork: true`, its NetworkPolicy
may not be enforced on all Container Network Interfaces (CNI). For example,
we have confirmed this NetworkPolicy will not be enforced with the Calico
CNI. Even if the NetworkPolicy is not enforced by your CNI, the
`kube-rbac-proxy` sidecar, if enabled, will still limit access to the Node
Exporter pods to the Prometheus ServiceAccount.
