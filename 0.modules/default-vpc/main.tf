resource "google_compute_network" "default" {
  name                    = var.network_name
  auto_create_subnetworks = "false"
  routing_mode            = "GLOBAL"
  project                 = var.project_id
}

locals {
  subnets = {
    for x in var.subnets :
    "${x.subnet_region}/${x.subnet_name}" => x
  }
}

resource "google_compute_subnetwork" "default" {
  for_each = local.subnets

  /*
  name                     = var.subnets[count.index]["subnet_name"]
  ip_cidr_range            = var.subnets[count.index]["subnet_ip"]
  region                   = var.subnets[count.index]["subnet_region"]
  */
  name                     = each.value.subnet_name
  ip_cidr_range            = each.value.subnet_ip
  region                   = each.value.subnet_region
  private_ip_google_access = "true"
  network                  = google_compute_network.default.name
  project                  = var.project_id
}

resource "google_compute_firewall" "fi-all-public-allow-ssh" {
  name    = "fi-all-public-allow-ssh"
  network = google_compute_network.default.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  target_tags   = ["all-allow-ssh"]
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "fi-all-public-allow-rdp" {
  name    = "fi-all-public-allow-rdp"
  network = google_compute_network.default.name

  allow {
    protocol = "tcp"
    ports    = ["3389"]
  }

  target_tags   = ["all-allow-rdp"]
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "fi-all-public-allow-icmp" {
  name    = "fi-all-public-allow-icmp"
  network = google_compute_network.default.name

  allow {
    protocol = "icmp"
  }

  target_tags   = ["all-allow-icmp"]
  source_ranges = ["0.0.0.0/0"]
}

