# Configrure the google provider
provider "google" {
  credentials = "${file(var.google_credentials_file)}"
  project     = "${var.project}"
  region      = "${var.region}"
}

# Configure the CloudFlare provider
provider "cloudflare" {
  email = "${var.cloudflare_email}"
  token = "${var.cloudflare_token}"
}
