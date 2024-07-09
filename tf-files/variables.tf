variable "region" {
  type    = string
  default = "eu-north-1"
}

variable "aws_dynamo_table_name" {
  type    = string
  default = "terraform-state-lock-dynamo"
}

variable "key_pair_name" {
  description = "key_pair_name"
  type        = string
  default     = "github_actions"
}

variable "instance_type" {
  description = "instance_type"
  type        = string
  default     = "t3.micro"
}

variable "instance_tag" {
  description = "Tag given to each deployed Instance"
  type        = string
  default     = "1.0.0"
}

variable "counter" {
  description = "Number of instances to launch"
  type        = number
  default     = 1
}

variable "availability_zone" {
  description = "Availability Zones for the Subnet"
  type        = string
  default     = "b"
}

variable "action_file" {
  description = "file that has the the actions to be performed on ec2 instance"
  type        = string
  default     = "install_local_app.sh"
}
