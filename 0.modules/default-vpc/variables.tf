variable "project_id" {
}

variable "network_name" {
  description = "The name of the network being created"
}

variable "subnets" {
  type        = list(map(string))
  description = "The list of subnets being created"
}