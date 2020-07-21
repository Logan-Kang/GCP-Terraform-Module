/*
export TF_VAR_credentials=/home/taurus/terraform/etc/owner-iaas-demo-208601-d21de940ef7a.json
export TF_VAR_project=iaas-demo-208601
*/

module "vpc" {
  source       = "../0.modules/default-vpc"
  project_id   = var.project
  network_name = "korea-host-test"

  subnets = [
    {
      subnet_name   = "s-an3-1"
      subnet_ip     = "10.0.0.0/18"
      subnet_region = "asia-northeast3"
    },
    {
      subnet_name   = "s-an3-2"
      subnet_ip     = "10.0.64.0/18"
      subnet_region = "asia-northeast3"
    },
    {
      subnet_name   = "s-an3-3"
      subnet_ip     = "10.0.128.0/18"
      subnet_region = "asia-northeast3"
    },
  ]
}

resource "google_compute_firewall" "fi-allow-internal" {
  depends_on = [module.vpc]
  name    = "fi-allow-internal"
  network = "korea-host-test"

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }
  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }
  allow {
    protocol = "icmp"
  }

  source_ranges = ["10.0.0.0/16"]
}
