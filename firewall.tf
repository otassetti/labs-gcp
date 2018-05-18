resource "google_compute_firewall" "default" {
  name    = "allowrules"
  network = "${google_compute_instance.vnomecompute1.network_interface.0.network}"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22", "80", "443"]
  }

}
