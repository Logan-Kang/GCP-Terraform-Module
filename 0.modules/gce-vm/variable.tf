resource "random_string" "prefix" {
  length  = 4
  special = false
  upper   = false
  number  = false
}

variable "instance-count" {}

variable "module_enabled" {
    default = true
}

variable "public_ip" {
    default = true
}

variable "add_disk" {
    default = true
}

variable "project-id" {
}

variable "instance-name" {
}

variable "machine-type" {
}

variable "instance-region" {
}

variable "network_tags" {
  type = list(string)
}

variable "subnet-name" {
  description = "The name of the network being created"
}

/*variable "instance-ip" {}*/

variable "image" {
  description = "image-project/image-family ex. centos-cloud/centos-7"
}

variable "disk-size" {
}

variable "disk-size2" {
}

variable "disk-type" {
}

variable "disk-type2" {
}

variable "startup-script" {
  description = "ex. gs://kcg-asia/agent.sh"
}

variable "cpu-platform" {

}

variable "labels_creator" {}

variable "labels_create-date" {}

variable "labels_env" {}