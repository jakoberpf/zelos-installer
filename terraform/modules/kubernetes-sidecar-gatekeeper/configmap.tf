resource "kubectl_manifest" "cloudflared_deployment" {
  yaml_body = <<-EOF
# This ConfigMap is just a way to define the cloudflared config.yaml file in k8s.
# It's useful to define it in k8s, rather than as a stand-alone .yaml file, because
# this lets you use various k8s templating solutions (e.g. Helm charts) to
# parameterize your config, instead of just using string literals.
apiVersion: v1
kind: ConfigMap
metadata:
  name: cloudflared
data:
  config.yaml: |
    # Name of the tunnel you want to run
    tunnel: example-tunnel
    credentials-file: /etc/cloudflared/creds/credentials.json
    # Serves the metrics server under /metrics and the readiness server under /ready
    metrics: 0.0.0.0:2000
    # Autoupdates applied in a k8s pod will be lost when the pod is removed or restarted, so
    # autoupdate doesn't make sense in Kubernetes. However, outside of Kubernetes, we strongly
    # recommend using autoupdate.
    no-autoupdate: true
    # The `ingress` block tells cloudflared which local service to route incoming
    # requests to. For more about ingress rules, see
    # https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/configuration/ingress
    #
    # Remember, these rules route traffic from cloudflared to a local service. To route traffic
    # from the internet to cloudflared, run `cloudflared tunnel route dns <tunnel> <hostname>`.
    # E.g. `cloudflared tunnel route dns example-tunnel tunnel.example.com`.
    ingress:
    # The first rule proxies traffic to the httpbin sample Service defined in app.yaml
    - hostname: tunnel.example.com
      service: http://web-service:80
    # This rule sends traffic to the built-in hello-world HTTP server. This can help debug connectivity
    # issues. If hello.example.com resolves and tunnel.example.com does not, then the problem is
    # in the connection from cloudflared to your local service, not from the internet to cloudflared.
    - hostname: hello.example.com
      service: hello_world
    # This rule matches any traffic which didn't match a previous rule, and responds with HTTP 404.
    - service: http_status:404
EOF

  depends_on = [
    kubernetes_namespace.longhorn
  ]
}
