variable "google_credentials_file" {
  description = "The google credentials file"
  default     = ""
}

variable "region" {
  description = "Region to deploy install in GCP"
  default     = "us-central1"
}

variable "project" {
  description = "Name of the Project in GCP"
  default     = "my-project"
}

variable "gce_ssh_user" {
  description = "SSH User of Pubclic key"
  default     = "user"
}

variable "gce_ssh_pub_key_file" {
  description = "SSH Public Key File to access the instance"
  default     = "~/.ssh/gcp.pub"
}

variable "instance_name" {
  description = "The instance name"
  default     = "myinstance"
}

variable "instance_zone" {
  description = "The Instance Zone"
  default     = "us-central1-c"
}

variable "instance_type" {
  description = "The Instance type"
  default     = "f1-micro"
}

variable "instance_tags" {
  description = "The instances TAGS (Tags also open  port http, https, ssh)"
  type        = "list"
  default     = ["ssh-server"]
}

variable "instance_boot_size" {
  description = "The instance boot disk size"
  default     = "30"
}

variable "instance_boot_type" {
  description = "The instance boot disk type"
  default     = "pd-standard"
}

variable "instance_os_image" {
  description = "the instance os/image"
  default     = "cos-cloud/cos-stable"
}

variable "instance_scopes" {
  description = "The instance scope"
  type        = "list"

  default = [
    "userinfo-email",
    "compute-ro",
    "storage-ro",
  ]
}

### Cloudflare Vars
variable "cloudflare_email" {
  description = "CloudFlare email"
}

variable "cloudflare_token" {
  description = "CloudFlare api token"
}

variable "cloudflare_domain" {
  description = "Target domain to update in Cloudlfare"
  default     = "my-domain.org"
}

variable "cloudflare_hostname" {
  description = "the target hostname"
  default     = "full-text-rss"
}


# Template Vars

variable "site_private_pem" {
  description = "the private ssl pem file for nginx ssl"
  default = ""
}