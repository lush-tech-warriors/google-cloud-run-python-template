variable "gcp-project-id" {
  type        = string
  description = "The id of the GCP project you wish to depoy your Cloud Run App too."
  # default = "tech-warriors-stage-global"
}

variable "owner" {
  type        = string
  description = "Owner of the repository. For example: The owner for https://github.com/googlecloudplatform/cloud-builders is 'googlecloudplatform'."
  # default = "LUSHDigital"
}

variable "name" {
  type        = string
  description = "Name of the repository. For example: The name for https://github.com/googlecloudplatform/cloud-builders is 'cloud-builders'."
  # default = "google-cloud-run-python-template"
}

variable "region" {
  type        = string
  description = "The GCP region you with to deploy in, for example use 'europe-west1' for London. "
  # default = "europe-west1"
}
