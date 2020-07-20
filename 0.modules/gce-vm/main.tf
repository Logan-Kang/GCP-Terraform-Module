/*
vm1 : vm with 1disk, external ip
vm2 : vm with 1disk, no external ip
vm3 : vm with 2disk, external ip
vm4 : vm with 2disk, no external ip
*/


resource "google_compute_address" "vm1-public-static-ip" {
  count = var.module_enabled && var.public_ip && ! var.add_disk ? var.instance-count : 0
  name = "${var.instance-name}-${random_string.prefix.result}-${format("%02d",count.index+1)}-ip"
  region = var.instance-region
}

resource "google_compute_address" "vm3-public-static-ip" {
  count = var.module_enabled && var.public_ip && var.add_disk ? var.instance-count : 0
  name = "${var.instance-name}-${random_string.prefix.result}-${format("%02d",count.index+1)}-ip"
  region = var.instance-region
}

resource "google_compute_disk" "vm3-add-disk" {
  count = var.module_enabled && var.public_ip && var.add_disk ? var.instance-count : 0
  name = "${var.instance-name}-${random_string.prefix.result}-${format("%02d",count.index+1)}-second"
  type = var.disk-type2
  zone = "${var.instance-region}-b"
  size = var.disk-size2
}

resource "google_compute_disk" "vm4-add-disk" {
  count = var.module_enabled && ! var.public_ip && var.add_disk ? var.instance-count : 0
  name = "${var.instance-name}-${random_string.prefix.result}-${format("%02d",count.index+1)}-second"
  type = var.disk-type2
  zone = "${var.instance-region}-b"
  size = var.disk-size2
}

resource "google_compute_instance" "gce-vm1" {
  count = var.module_enabled && var.public_ip && ! var.add_disk ? var.instance-count : 0
  project      = var.project-id
  name         = "${var.instance-name}-${random_string.prefix.result}-${format("%02d",count.index+1)}"
  machine_type = var.machine-type
  zone         = "${var.instance-region}-b"

  tags = var.network_tags

  boot_disk {
    initialize_params {
      image = var.image
      size  = var.disk-size
      type  = var.disk-type
    }
  }

  network_interface {
    subnetwork = var.subnet-name
    //network_ip = var.instance-ip
    access_config {
      nat_ip = google_compute_address.vm1-public-static-ip[count.index].address
    }
  }

  metadata = {
    startup-script = var.startup-script
  }

  service_account {
    scopes = ["cloud-platform"]
  }

  min_cpu_platform = var.cpu-platform

  labels = {
    creator = var.labels_creator
    create-date = var.labels_create-date
    env = var.labels_env
  }
  
  allow_stopping_for_update = true
}

resource "google_compute_instance" "gce-vm2" {
  count = var.module_enabled && ! var.public_ip && ! var.add_disk ? var.instance-count : 0
  project      = var.project-id
  name         = "${var.instance-name}-${random_string.prefix.result}-${format("%02d",count.index+1)}"
  machine_type = var.machine-type
  zone         = "${var.instance-region}-b"

  tags = var.network_tags

  boot_disk {
    initialize_params {
      image = var.image
      size  = var.disk-size
      type  = var.disk-type
    }
  }

  network_interface {
    subnetwork = var.subnet-name
  }

  metadata = {
    startup-script = var.startup-script
  }

  service_account {
    scopes = ["cloud-platform"]
  }

  min_cpu_platform = var.cpu-platform

  labels = {
    creator = var.labels_creator
    create-date = var.labels_create-date
    env = var.labels_env
  }
  
  allow_stopping_for_update = true
}

resource "google_compute_instance" "gce-vm3" {
  count = var.module_enabled && var.public_ip && var.add_disk ? var.instance-count : 0
  project      = var.project-id
  name         = "${var.instance-name}-${random_string.prefix.result}-${format("%02d",count.index+1)}"
  machine_type = var.machine-type
  zone         = "${var.instance-region}-b"

  tags = var.network_tags

  boot_disk {
    initialize_params {
      image = var.image
      size  = var.disk-size
      type  = var.disk-type
    }
  }

  attached_disk {
    source = google_compute_disk.vm3-add-disk[count.index].name
    mode   = "READ_WRITE"
  }

  network_interface {
    subnetwork = var.subnet-name
    //network_ip = var.instance-ip
    access_config {
      nat_ip = google_compute_address.vm3-public-static-ip[count.index].address
    }
  }

  metadata = {
    startup-script = var.startup-script
  }

  service_account {
    scopes = ["cloud-platform"]
  }

  min_cpu_platform = var.cpu-platform

  labels = {
    creator = var.labels_creator
    create-date = var.labels_create-date
    env = var.labels_env
  }

  allow_stopping_for_update = true
}

resource "google_compute_instance" "gce-vm4" {
  count = var.module_enabled && ! var.public_ip && var.add_disk ? var.instance-count : 0
  project      = var.project-id
  name         = "${var.instance-name}-${random_string.prefix.result}-${format("%02d",count.index+1)}"
  machine_type = var.machine-type
  zone         = "${var.instance-region}-b"

  tags = var.network_tags

  boot_disk {
    initialize_params {
      image = var.image
      size  = var.disk-size
      type  = var.disk-type
    }
  }

  attached_disk {
    source = google_compute_disk.vm4-add-disk[count.index].name
    mode   = "READ_WRITE"
  }

  network_interface {
    subnetwork = var.subnet-name
  }

  metadata = {
    startup-script = var.startup-script
  }

  service_account {
    scopes = ["cloud-platform"]
  }

  min_cpu_platform = var.cpu-platform

/*
  for_each = local.labels

  labels = {
    creator = lookup(var.labels, "creator", "taurus")
    create-date = lookup(var.labels, "create-date", null)
    env = lookup(var.labels, "env", null)
  }
  */

  labels = {
    creator = var.labels_creator
    create-date = var.labels_create-date
    env = var.labels_env
  }

  allow_stopping_for_update = true
}