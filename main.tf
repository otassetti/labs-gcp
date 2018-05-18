resource "google_compute_address" "vnomecompute1-static-ip" {
  name = "vnomecompute1-static-ip-static-ip-address"
}


resource "google_compute_instance" "vnomecompute1" {
  name         = "vnomecompute1"
  machine_type = "f1-micro"
  zone         = "us-central1-c"

  tags = ["free", "vnomelabs"]

  boot_disk {
    initialize_params {
      size  = 30
      type = "pd-standard"
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    network = "default"
    access_config {
      nat_ip = "${google_compute_address.vnomecompute1-static-ip.address}"
    }
  }

  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }
}
