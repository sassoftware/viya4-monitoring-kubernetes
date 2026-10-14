# Gateway API

## Overview

This sample demonstrates how to configure [Gateway API](https://gateway-api.sigs.k8s.io/)
`HTTPRoute` resources for accessing the web applications that are deployed as
part of the SAS Viya Monitoring for Kubernetes solution.

Gateway API is a vendor-neutral ingress specification published by Kubernetes
SIG-Network. The only implementation-specific value in this sample is
`spec.gatewayClassName` on the `Gateway` you attach to.

> [!IMPORTANT]
> The customization files in this sample can be applied manually, as described
> below, or generated and applied automatically by setting
> `AUTOGENERATE_INGRESS=true` and `INGRESS_TYPE=gateway-api`. See
> [Autogeneration](#autogeneration).

> [!IMPORTANT]
> Your implementation needs **Extended** conformance, not just Core. The
> `URLRewrite` filter used for path-based routing is Extended-level, and
> `ListenerSet` (see [ListenerSet Ownership](#listenerset-ownership)) requires
> Gateway API v1.4.0 or later.

`BackendTLSPolicy` is part of the Standard channel as of Gateway API v1.4.0
and is served as `v1`; this sample uses `v1`. If your cluster runs an older
release, check which versions it actually serves:

```
kubectl get crd backendtlspolicies.gateway.networking.k8s.io -o jsonpath='{.spec.versions[?(@.served==true)].name}'
```

If `v1` isn't in the list, use a manifest matching whichever version your
cluster actually serves (for example `v1alpha3`), or upgrade your Gateway API
CRDs to a release that serves `v1`.

## Scenarios

Two scenarios are provided:

* **host-based routing** — the application name is part of the host name
  (for example, `https://grafana.monitoring.host.cluster.example.com/`). The
  `monitoring`/`logging` segment is required -- see
  [ListenerSet Ownership](#listenerset-ownership).
* **path-based routing** — the host name is fixed and the application name is
  appended as a path (for example, `https://monitoring.host.cluster.example.com/grafana`).

## Contents

```
host-based/{monitoring,logging}/
path-based/{monitoring,logging}/
    listenerset.yaml               attaches our own hostname/TLS cert to the shared Gateway
    http-redirect_httproute.yaml   explicit HTTP -> HTTPS redirect
    <app>_httproute.yaml           one per web application
    user-values-*.yaml             Helm/deployment customizations
```

There is no `gateway.yaml`. The `Gateway` is owned and managed by your
platform or cluster administrator, not created by this sample -- see
[Gateway Ownership](#gateway-ownership). `listenerset.yaml`, by contrast, is
ours: see [ListenerSet Ownership](#listenerset-ownership).

## Using This Sample

1. Find the `GatewayClass` name and the name/namespace of an existing
   `Gateway` you can attach to:

   ```
   kubectl get gatewayclass
   kubectl get gateway -A
   ```

2. Copy the customization files from either the `host-based` or `path-based`
   subdirectories into your local customization directory (that is, your
   `USER_DIR`).
3. Replace all instances of `host.cluster.example.com` with the applicable
   host name for your environment.
4. Confirm the Gateway allows `ListenerSet`s to attach from outside its own
   namespace (`spec.allowedListeners.namespaces.from: All`, or a matching
   `Selector`):

   ```
   kubectl -n <gateway-namespace> get gateway <gateway-name> \
     -o jsonpath='{.spec.allowedListeners.namespaces.from}'
   ```

   If this isn't `All` or a matching `Selector`, your `ListenerSet` will
   attach nowhere; ask whoever manages the Gateway to widen it.
5. Deploy SAS Viya Monitoring for Kubernetes.
6. Create the TLS Secret `listenerset.yaml` references
   (`v4m-ingress-tls-secret` by default) -- this is the cert your own
   namespace's listener presents, not the Gateway owner's. For host-based
   routing it must cover every app hostname in use (for example via a
   wildcard SAN matching `*.monitoring.host.cluster.example.com`).
7. Create the CA ConfigMap `BackendTLSPolicy` requires (see
   [CA certificates](#ca-certificates-must-be-in-a-configmap-not-a-secret)),
   and apply a `BackendTLSPolicy` for each app you're exposing. Application
   backends serve HTTPS by default, so without this the Gateway sends
   plaintext to a TLS-only backend and every request fails.
8. Set `spec.parentRef` in `listenerset.yaml` to your Gateway's actual name
   and namespace, then apply the routing resources:

   ```
   kubectl -n monitoring apply -f $USER_DIR/monitoring/listenerset.yaml
   kubectl -n monitoring apply -f $USER_DIR/monitoring/grafana_httproute.yaml
   kubectl -n monitoring apply -f $USER_DIR/monitoring/http-redirect_httproute.yaml
   ```

`AUTOGENERATE_INGRESS=true` with `INGRESS_TYPE=gateway-api` does all of the
above for you as part of a normal deploy -- see [Autogeneration](#autogeneration).

### Making secondary applications accessible

**This sample does NOT recommend making Prometheus and Alertmanager accessible
by default. Neither includes any native authentication mechanism, and exposing
such an application without other restrictions in place is insecure. It also does
NOT recommend making the OpenSearch API endpoint accessible by default; although
it does require authentication, there are limited use cases requiring it.**

Files for these applications are included should you need them. Apply the
relevant `_httproute.yaml`, write a `BackendTLSPolicy` for it (its backend
serves HTTPS by default, same as the others), and uncomment the corresponding
section of `user-values-prom-operator.yaml`.

## Gateway Ownership

The `Gateway` resource is owned and managed by the platform or cluster
administrator, not by SAS Viya Monitoring for Kubernetes. This sample assumes
one already exists and never creates or modifies it.

It's expected to be a single, shared Gateway that other namespaces attach
their own `ListenerSet`s to. It can live in any namespace. Its only
requirement is `spec.allowedListeners.namespaces.from: All` (or a matching
`Selector`) -- see [ListenerSet Ownership](#listenerset-ownership).

## ListenerSet Ownership

Unlike the `Gateway`, `listenerset.yaml` **is** ours: it's how a tenant
namespace attaches its own hostname and TLS cert to a Gateway it doesn't own,
without the Gateway owner having to provision anything on its behalf. Each of
`monitoring` and `logging` gets its own `ListenerSet`, in its own namespace,
with its own TLS Secret in that same namespace -- there's no cross-namespace
Secret reference, and no `ReferenceGrant` needed.

`spec.parentRef` points at the shared Gateway (name/namespace both required,
since the Gateway can live in any namespace). Its listeners' hostnames are
based on `BASE_DOMAIN`, same as the rest of this sample.

**Both routing modes require a namespace segment in the hostname** --
`grafana.monitoring.<domain>` for host-based, `monitoring.<domain>` (as the
single shared hostname for every app in that namespace) for path-based --
and this isn't just a convention carried over from Contour. Each of
`monitoring` and `logging` owns its *own* `ListenerSet` attached to the same
shared Gateway, and Gateway API will not let two separate listeners -- even
in different `ListenerSet`s -- claim the same hostname on the same port. For
host-based, that means a flat `*.<domain>` wildcard in both namespaces'
`ListenerSet`s would be indistinguishable over TLS SNI and gets rejected
outright (`reason: HostnameConflict`); for path-based, two `ListenerSet`s
both using the literal, identical `<domain>` (no segment) hit the exact same
rejection, just without a wildcard involved. The per-namespace segment is
what keeps the two apart in both cases -- it's not optional, and dropping it
to get a "cleaner" URL breaks routing for whichever namespace loses the
conflict.

## Backend TLS Is a Separate Resource

There's no per-`backendRef` TLS field; backend re-encryption is configured
out-of-band by a `BackendTLSPolicy` that targets the `Service`. Two things
follow from this.

### CA certificates must be in a ConfigMap, not a Secret

`BackendTLSPolicy.validation.caCertificateRefs` accepts a `ConfigMap`. TLS
Secrets created by the deployment scripts don't produce one, so extract the
CA public certificate and create it yourself:

```
kubectl -n monitoring get secret grafana-tls-secret \
  -o jsonpath='{.data.ca\.crt}' | base64 -d > ca.crt
kubectl -n monitoring create configmap v4m-ca-certs --from-file=ca.crt=ca.crt
```

`AUTOGENERATE_INGRESS=true` deployments don't need this -- the deploy scripts
do it automatically (`create_backend_tls_ca_configmap` in
`bin/autogenerate-include.sh`) when `INGRESS_BACKEND_TLS_ENABLE=true`.

### The hostname to validate is not the Service name

`validation.hostname` is matched against the SANs on the backend's serving
certificate. Confirm the actual SAN before writing a `BackendTLSPolicy` by
hand:

```
kubectl -n monitoring get secret grafana-tls-secret \
  -o jsonpath='{.data.tls\.crt}' | base64 -d \
  | openssl x509 -noout -text | grep -A1 'Subject Alternative Name'
```

`AUTOGENERATE_INGRESS=true` deployments don't need this -- the deploy scripts
read the SAN off the actual issued cert.

## Other Notes

* **No regex path rewrite.** Regex matching is implementation-specific in
  Gateway API. The path-based routes instead use an ordered pair of rules: an
  `Exact` match on the unslashed path with a `RequestRedirect` to the slashed
  form, then a `PathPrefix` match on the slashed path that routes to the
  backend (`Exact` outranks `PathPrefix` in Gateway API's match precedence,
  so this resolves deterministically). For OpenSearch Dashboards and the
  OpenSearch API, the second rule also carries a `URLRewrite` filter with
  `ReplacePrefixMatch: /` to strip the path prefix before forwarding.
* **Proxy tuning is a documentation matter.** There's no portable Gateway API
  mechanism for buffer sizes, header sizes, or timeouts. Apply these to the
  Gateway, the `ListenerSet`, or the implementation's own configuration.
* **The HTTP listener only ever serves a redirect.** `http-redirect_httproute.yaml`
  has no `backendRefs`, so no application content is ever returned over plain
  HTTP. For example, `http://grafana.monitoring.<domain>/` gets a `301`
  pointing at `https://grafana.monitoring.<domain>/`; the actual Grafana page
  is only ever served over HTTPS. "HTTP exposed" here just means port 80 is
  open at all and answers with that redirect. Removing the HTTP listener from
  `listenerset.yaml` (and not applying `http-redirect_httproute.yaml`) closes
  port 80 entirely, so `http://grafana.monitoring.<domain>/` gets no response
  instead of a redirect; `https://grafana.monitoring.<domain>/` is unaffected
  either way.

## Confirm the Status of the Resources

Gateway API reports reconciliation results in resource status conditions.
Check the Gateway, then the `ListenerSet`, then the routes:

```
kubectl -n <gateway-namespace> get gateway <gateway-name>
kubectl -n monitoring get listenerset v4m-listenerset
kubectl -n monitoring describe listenerset v4m-listenerset
kubectl -n monitoring describe httproute v4m-grafana
```

On the `Gateway`, `Programmed: False` with reason `AddressNotAssigned` is
normal on clusters with no real `LoadBalancer` (common on-prem); it does not
block routing. What does matter is `spec.allowedListeners.namespaces.from`
(see [step 4](#using-this-sample)).

On the `ListenerSet`, look for `Accepted: True` and `Programmed: True`, and
per listener, `ResolvedRefs: True` -- a missing TLS Secret shows up as
`ResolvedRefs: False` with reason `InvalidCertificateRef`, and two
namespaces' listeners with the same (or overlapping wildcard) hostname show
up as `Conflicted: True` with reason `HostnameConflict` (see
[ListenerSet Ownership](#listenerset-ownership)).

On each `HTTPRoute`, look at `status.parents[].conditions` for
`Accepted: True` and `ResolvedRefs: True`; a route that attached to no
listener reports `Accepted: False` with reason `NoMatchingListenerHostname`,
which usually means the route's `hostnames` do not fall within the
`ListenerSet`'s listener `hostname`.

`BackendTLSPolicy` status is reported under `status.ancestors[]`; a missing
CA ConfigMap surfaces there as `ResolvedRefs: False`.

## Access the Applications

Replace the placeholder host names with the ones you specified.

### Host-based

* Grafana — `https://grafana.monitoring.host.cluster.example.com`
* OpenSearch Dashboards — `https://dashboards.logging.host.cluster.example.com`
* Prometheus — `https://prometheus.monitoring.host.cluster.example.com` (if enabled)
* Alertmanager — `https://alertmanager.monitoring.host.cluster.example.com` (if enabled)
* OpenSearch — `https://search.logging.host.cluster.example.com` (if enabled)

### Path-based

* Grafana — `https://monitoring.host.cluster.example.com/grafana`
* OpenSearch Dashboards — `https://logging.host.cluster.example.com/dashboards`
* Prometheus — `https://monitoring.host.cluster.example.com/prometheus` (if enabled)
* Alertmanager — `https://monitoring.host.cluster.example.com/alertmanager` (if enabled)
* OpenSearch — `https://logging.host.cluster.example.com/opensearch` (if enabled)

## Autogeneration

`AUTOGENERATE_INGRESS=true` with `INGRESS_TYPE=gateway-api` generates and
applies the `ListenerSet` and `HTTPRoute` resources shown in this sample as
part of a normal deploy.

Required: `GATEWAY_CLASS_NAME`, `GATEWAY_NAMESPACE`, and `GATEWAY_NAME`. A
Gateway matching all three must already exist, with
`spec.allowedListeners.namespaces.from` set to allow `ListenerSet`s from
outside its own namespace; the deploy scripts verify all of this and fail
with a clear error if it's not met. The Gateway itself is never created by
the deploy scripts; see [Gateway Ownership](#gateway-ownership). Its own
`ListenerSet` and TLS Secret, by contrast, are created automatically -- see
[ListenerSet Ownership](#listenerset-ownership).

The existing per-application enable flags (`GRAFANA_INGRESS_ENABLE` and
friends) and the FQDN/path override variables carry through unchanged. There
is no `INGRESS_CREATE_ROOT_PROXY` equivalent. For host-based routing, each
app's default FQDN automatically includes its namespace segment
(`grafana.monitoring.$BASE_DOMAIN`); an explicit `GRAFANA_FQDN` (and so on)
overrides this entirely, same as for the other ingress types.

Backend re-encryption via `BackendTLSPolicy` is on by default
(`INGRESS_BACKEND_TLS_ENABLE=true`), since application backends serve HTTPS
by default and Gateway API has no per-route TLS toggle. The deploy scripts
read `validation.hostname` off the actual issued cert, so it works regardless
of which TLS flow is active.
