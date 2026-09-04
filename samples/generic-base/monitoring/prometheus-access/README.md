# Granting Access to the Prometheus API/UI

When `RBAC_PROXY_ENABLE=true` (the default), the Prometheus HTTP endpoint
(`v4m-prometheus:9090`, i.e. the query API and the web UI) sits behind a
`kube-rbac-proxy` sidecar. Every request must carry a Kubernetes bearer token
(`Authorization: Bearer ...`) whose subject is allowed to `get` (for GET) and
`create` (for POST) the `services/v4m-prometheus` subresource in the monitoring
namespace. Prometheus itself and Grafana are granted this automatically.

To grant any other ServiceAccount, user, or group, bind them to a Role such as
the one in [prometheus-client.yaml](prometheus-client.yaml):

```bash
# Edit the subjects in prometheus-client.yaml first, then:
kubectl apply -n monitoring -f prometheus-client.yaml
```

To call the API from a shell, request a short-lived token for a ServiceAccount
that has been bound (here `prometheus-client` from the sample) and pass it as a
bearer token. The sidecar always serves HTTPS; when `TLS_ENABLE=false` its
certificate is self-signed, so add `-k`:

```bash
TOKEN=$(kubectl -n monitoring create token prometheus-client)
curl -sk -H "Authorization: Bearer $TOKEN" \
  https://prometheus.host.cluster.example.com/api/v1/query?query=up
```

Browsers cannot attach a bearer token to the Prometheus UI on their own, so if
you expose Prometheus through an ingress and need interactive access, either
use Grafana's Explore view (which is already authorized) or put an
authenticating reverse proxy (e.g. OAuth2 Proxy) in front of the ingress that
injects the `Authorization` header.

Setting `RBAC_PROXY_ENABLE=false` removes the sidecar (Prometheus is then
unauthenticated again, over TLS or not depending on `TLS_ENABLE`).
