provider "google-beta" {
  project     = var.gcp-project-id
  region      = var.region
}

resource "google_cloudbuild_trigger" "filename-trigger"  {
  provider = google-beta

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
