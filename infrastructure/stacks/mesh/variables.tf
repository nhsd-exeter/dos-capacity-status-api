
##################################################################################
# INFRASTRUCTURE COMPONENT VERSION
##################################################################################
variable "version_tag" {
  description = "The infrastructure component version assigned by Texas development. The version MUST be incremented when changed <major version>.<minor version>"
  default     = "1.0"
}

##################################################################################
# AWS COMMON
##################################################################################
variable "aws_region" {
  description = "The AWS region"
}

variable "aws_profile" {
  description = "The AWS profile"
}

####################################################################################
# TEXAS COMMON
####################################################################################
variable "billing_code_tag" {
  description = "The tag used to identify component for billing purposes"
}

variable "environment_tag" {
  description = "The tag used to identify component environment"
}

variable "service_prefix" {
  description = "Prefix used for naming resources"
}

variable "service_name" {
  description = "The tag used to identify the service the resource belongs to"
}

##################################################################################
# MESH
##################################################################################

variable "mesh_name" {
  description = "The name of the service mesh"
}
