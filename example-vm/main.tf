/*
export TF_VAR_credentials=/home/taurus/terraform/etc/owner-iaas-demo-208601-d21de940ef7a.json
export TF_VAR_project=iaas-demo-208601

*/

module "vm1_1disk_extip" {
  source              = "../0.modules/gce-vm"
  module_enabled      = true
  public_ip           = true
  add_disk            = false
  instance-count      = 1
  project-id          = var.project
  instance-name       = "kcg-vm1"
  machine-type        = "n1-standard-2"
  instance-region     = "asia-northeast3"
  cpu-platform        = "Intel Skylake"
  network_tags        = ["internal","external"]
  subnet-name         = "default"
  image               = "centos-cloud/centos-7"
  disk-type           = "pd-standard"
  disk-size           = "20"
  labels_creator      = "taurus"
  labels_create-date  = "200720"
  labels_env          = "test"
  startup-script      = "${file("stackdriver-agent.sh")}"
  # this is null(garbage)
  disk-type2          = "pd-standard"  # data not applicable
  disk-size2          = "20"           # data not applicable
}

module "vm2_1disk_intip" {
  source              = "../0.modules/gce-vm"
  module_enabled      = true
  public_ip           = false
  add_disk            = false
  instance-count      = 1
  project-id          = var.project
  instance-name       = "kcg-vm2"
  machine-type        = "n1-standard-2"
  instance-region     = "asia-northeast3"
  cpu-platform        = "Intel Skylake"
  network_tags        = ["internal"]
  subnet-name         = "default"
  image           = "centos-cloud/centos-7"
  disk-type       = "pd-standard"
  disk-size       = "20"
  labels_creator  = "taurus"
  labels_create-date = "200720"
  labels_env      = "test"
  startup-script = "${file("stackdriver-agent.sh")}"
  # this is null(garbage)
  disk-type2         = "pd-standard"  # data not applicable
  disk-size2         = "20"           # data not applicable
}

module "vm3-2disk-extip" {
  source          = "../0.modules/gce-vm"
  module_enabled  = true
  public_ip       = true
  add_disk        = true
  instance-count  = 1
  project-id      = var.project
  instance-name   = "kcg-vm3"
  machine-type    = "n1-standard-1"
  instance-region = "asia-northeast3"
  cpu-platform    = "Intel Skylake"
  network_tags    = ["internal","external"]
  subnet-name     = "default"
  image           = "centos-cloud/centos-7"
  disk-type       = "pd-standard"
  disk-size       = "20"
  labels_creator  = "taurus"
  labels_create-date = "200720"
  labels_env      = "test"
  startup-script = "${file("stackdriver-agent.sh")}"
  # second disk
  disk-type2         = "pd-standard"
  disk-size2         = "20"
}

module "vm4-2disk-intip" {
  source          = "../0.modules/gce-vm"
  module_enabled  = true
  public_ip       = false
  add_disk        = true
  instance-count  = 1
  project-id      = var.project
  instance-name   = "kcg-vm4"
  machine-type    = "n1-standard-1"
  instance-region = "asia-northeast3"
  cpu-platform    = "Intel Skylake"
  network_tags    = ["internal"]
  subnet-name     = "default"
  image           = "centos-cloud/centos-7"
  disk-type       = "pd-standard"
  disk-size       = "20"
  labels_creator  = "taurus"
  labels_create-date = "200720"
  labels_env      = "test"
  startup-script  = "${file("stackdriver-agent.sh")}"
  # second disk
  disk-type2         = "pd-standard"
  disk-size2         = "20"
}