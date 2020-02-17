resource "google_project_service" "gps_cm" {
  project = var.project
  service = "cloudresourcemanager.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "gps_cp" {
  project = var.project
  service = "compute.googleapis.com"
  disable_on_destroy = false
  depends_on = [google_project_service.gps_cm]
}

resource "google_project_service" "gps_iam" {
  project = var.project
  service = "iam.googleapis.com"
  disable_on_destroy = false
  depends_on = [google_project_service.gps_cm]
}

resource "google_project_service" "gps_st" {
  project = var.project
  service = "servicemanagement.googleapis.com"
  disable_on_destroy = false
  depends_on = [google_project_service.gps_cm]
}
