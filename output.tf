output "public_ip" {
  value = "${google_compute_address.vnomecompute1-static-ip.address}"
}