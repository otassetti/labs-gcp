# labs-gcp

##### What this labs do

It will deploy the php application [FullText-Rss](http://fivefilters.org/content-only/) using 2 dockers containers using [cloud-init](https://cloud.google.com/container-optimized-os/docs/how-to/create-configure-instance#using_cloud-init) on a google compute instance using [Container-Optimized OS](https://cloud.google.com/container-optimized-os/docs/)
>The target instance is set to f1-micro, on us-central1-c zone with 30go disk so it fit in the [Always free tiers of GCP](https://cloud.google.com/free/)

It will use [Cloudlfare services](https://www.cloudflare.com) to manage dns and SSL certificate.

##### Prerequisites

1. Having a account on google cloud platform and existing project
2. Having a cloudflare account and a domain to it. 
 
 
##### 1. Create Authentication tokens
The first things to do it to create a token on gcp and cloudflare that will be used by terraform for authentification on those services.

###### For GCP
From https://cloud.google.com/storage/docs/authentication, generate a private key in JSON and download it to as secure place.

###### For Cloudflare

From https://support.cloudflare.com/hc/en-us/articles/200167836-Where-do-I-find-my-Cloudflare-API-key-, create a personnal api keys and save it somewhere secured.

##### 2. Create a intermediate Cloudfare certificate

Cloudflare will be used to provide the Final SSL certificate for you domain, but the traffic need to be encrypted
between clouflare and your host, for this you need to create an origin certificate.
Origin Certificates.

From : https://support.cloudflare.com/hc/en-us/articles/115000479507, you will generate Public and Private origin certificates.

NB: For this example we will reference this file as private.pem

#### 3. SSH Key to access the Gcp Instance

We need to generate private and public key to add to our compute machine.

```
 otassetti  ~  ssh-keygen -t rsa  -f /home/user/.ssh/gcp
Generating public/private rsa key pair.
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /home/user.ssh/gcp.
Your public key has been saved in /home/user/.ssh/gcp.pub.
The key fingerprint is:
SHA256:nlMx36Q5HFYCTbCM7EAVk6JYoFLiLp6k9xUDhgKD3O8 user@local
The key's randomart image is:
+---[RSA 2048]----+
|* +.  ..+oo=o .  |
|+* o.....+ ..o   |
|+..o+...o = o .  |
|o....o o   * *   |
|.o  . o S . * .  |
|= .  E + o   .   |
|.o.   . +        |
| . . .   .       |
|    .            |
+----[SHA256]-----+

```

##### 3. Installing terraform 

The instruction can be found here depending on you plaform: 
https://www.terraform.io/intro/getting-started/install.html

##### 4. Configuration of Terraform Variables.

You will need to add variables corresponding to you project.
For example 
```
$ vim terraform.tfvars

#My gcp token
google_credentials_file = "/home/user/mytoken.json"
#Gcp Project to use
project = "myproject1"
#Gcp name of my instance
instance_name = "myvm1"
#Gcp Tags also used to open port
instance_tags = ["free", "ssh-server", "http-server", "https-server", "myproject1"]

#Cloudflare accoutn email
cloudflare_email = "user@domain.com"
#Cloudflaure hostname
cloudflare_hostname = "website"
#Cloudlflare domain to use
cloudflare_domain = "mydomain.com"
#Cloudfare personal token
cloudflare_token = "XXXXXXXXXXXXXX"
#Cloudflare private origin key
site_private_pem = "/home/user/cloudflare/private.pem"

#My ssh user on the instance
gce_ssh_user = "user"
#My public key to connect to the instance
gce_ssh_pub_key_file = "/home/user/.ssh/gcp.pub"
```

##### 5. Initialisation of Terraform backen

We will use google cloud storage as a backend to store our tfstate, so we need to init it first

>NB: We need to export google credential, because initialisation take place befor any terraform action, so terraform have not access to our tfvars at this state.

```
$ export GOOGLE_APPLICATION_CREDENTIALS="/home/user/mytoken.json"

$ terraform init


Initializing the backend...

Initializing provider plugins...

The following providers do not have any version constraints in configuration,
so the latest version was installed.

To prevent automatic upgrades to new major versions that may contain breaking
changes, it is recommended to add version = "..." constraints to the
corresponding provider blocks in configuration, with the constraint strings
suggested below.

* provider.cloudflare: version = "~> 1.2"
* provider.google: version = "~> 1.17"
* provider.template: version = "~> 1.0"
....
```

##### 6. Create the instance

If all is set correctly we can now use plan/apply to deploy our project.
```
$ terraform plan

Refreshing Terraform state in-memory prior to plan...
The refreshed state will be used to calculate this plan, but will not be
persisted to local or remote state storage.

data.template_file.init: Refreshing state...

------------------------------------------------------------------------

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  + cloudflare_record.myrecord
      id:                                                  <computed>
      created_on:                                          <computed>
      domain:                                              "mydomain.com"
      hostname:                                            <computed>
      metadata.%:                                          <computed>
      modified_on:                                         <computed>
      name:                                                "website"
      proxiable:                                           <computed>
      proxied:                                             "true"
      ttl:                                                 "1"
      type:                                                "A"
      value:                                               "${google_compute_instance.myinstance.network_interface.0.access_config.0.nat_ip}"
      zone_id:                                             <computed>

  + google_compute_instance.myinstance
      id:                                                  <computed>
      boot_disk.#:                                         "1"
      boot_disk.0.auto_delete:                             "true"
      boot_disk.0.device_name:                             <computed>
      boot_disk.0.disk_encryption_key_sha256:              <computed>
      boot_disk.0.initialize_params.#:                     "1"
      boot_disk.0.initialize_params.0.image:               "cos-cloud/cos-stable"
      boot_disk.0.initialize_params.0.size:                "30"
      boot_disk.0.initialize_params.0.type:                "pd-standard"
      can_ip_forward:                                      "false"
      cpu_platform:                                        <computed>
      create_timeout:                                      "4"
      deletion_protection:                                 "false"
      guest_accelerator.#:                                 <computed>
      instance_id:                                         <computed>
      label_fingerprint:                                   <computed>
      machine_type:                                        "f1-micro"
      metadata.%:                                          "2"
....
Plan: 2 to add, 0 to change, 0 to destroy.
```

then 

```
$ terraform apply
....
Apply complete! Resources: 2 added, 0 changed, 0 destroyed.

Outputs:

public_ip = 104.111.78.101

```


> After few minute you can access your project directly using is public ip, or using website.mydomain.com, to access it using cloudlflare ssl.
