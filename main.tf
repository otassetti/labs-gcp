# Create a simple GCP Compute instance
resource "google_compute_instance" "myinstance" {
  name         = "${var.instance_name}"
  machine_type = "${var.instance_type}"
  zone         = "${var.instance_zone}"

  tags = "${var.instance_tags}"

  boot_disk {
    initialize_params {
      size  = "${var.instance_boot_size}"
      type  = "${var.instance_boot_type}"
      image = "${var.instance_os_image}"
    }
  }

  network_interface {
    network       = "default"
    access_config = {}
  }

  service_account {
    scopes = "${var.instance_scopes}"
  }

  metadata {
    sshKeys   = "${var.gce_ssh_user}:${file(var.gce_ssh_pub_key_file)}"
    //user-data = "${file("cloud-init.cfg")}"
    user-data = "${data.template_file.init.rendered}"
  }
}
