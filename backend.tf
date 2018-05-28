terraform {
  backend "gcs" {
    bucket  = "vnomelab-terraform-state"
    path    = "gcp/terraform.tfstate"
    project = "vnomelab"
  }
}
