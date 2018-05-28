# Add a record to the domain
resource "cloudflare_record" "myrecord" {
  domain  = "${var.cloudflare_domain}"
  name    = "${var.cloudflare_hostname}"
  value   = "${google_compute_instance.myinstance.network_interface.0.access_config.0.nat_ip}"
  type    = "A"
  ttl     = 1
  proxied = "true"
}
