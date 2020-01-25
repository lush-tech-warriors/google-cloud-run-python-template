provider "google" {
  project     = var.gcp-project-id
  region      = var.region
}

resource "google_cloudbuild_trigger" "filename-trigger"  {
  provider = google

  github {
    owner = var.owner
    name = var.name
    push {
      branch = "master"
      }
}

  substitutions = {
    _REGION = var.region
}

  filename = "cloudbuild.yaml"
}

output "url" {
  value = google_cloudbuild_trigger.filename-trigger.status[0].url
}
