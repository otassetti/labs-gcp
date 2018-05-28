# Template to create the cloud init
data "template_file" "init" {
  template = "${file("cloud-init.cfg")}"

  vars {
    site_private_pem = "${file(var.site_private_pem)}"
  }
}