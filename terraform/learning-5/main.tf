resource "random_id" "rnd" {
  byte_length = 4
}

provider "google" {
  credentials = file(var.credentials_file)
  region  = var.region
  zone    = var.zone
  project = var.project
}

module "project_services" {
  source  = "../modules/services"
  project = var.project
}

resource "google_dns_managed_zone" "root" {
  name     = "root-zone"
  visibility = "public"
  description = "Root domain"

  dns_name = "${var.domain}."
  depends_on = [module.project_services]
}


# resource "google_dns_managed_zone" "subdmn" {
#   name     = "test-su-domain"
#   visibility = "public"
#   description = "Test domain"

#   dns_name = "test.${var.domain}."
#   depends_on = [module.project_services]
# }


# # Name server
# resource "google_dns_record_set" "ns" {
#   name         = google_dns_managed_zone.root.dns_name
#   managed_zone = google_dns_managed_zone.root.name
#   type         = "NS"
#   ttl          = 60

#   rrdatas = [
#     "ns-cloud-a1.googledomains.com.",
#     "ns-cloud-a2.googledomains.com.",
#     "ns-cloud-a3.googledomains.com.",
#     "ns-cloud-a4.googledomains.com."
#   ]
# }

# # Name server
# resource "google_dns_record_set" "ns-sub" {
#   name         = "test.${google_dns_managed_zone.root.dns_name}"
#   managed_zone = google_dns_managed_zone.root.name
#   type         = "NS"
#   ttl          = 60

#   rrdatas = [
#     "ns-cloud-a1.googledomains.com.",
#     "ns-cloud-a2.googledomains.com.",
#     "ns-cloud-a3.googledomains.com.",
#     "ns-cloud-a4.googledomains.com."
#   ]
# }

resource "google_dns_record_set" "a" {
  name         = "@.${google_dns_managed_zone.root.dns_name}"
  managed_zone = google_dns_managed_zone.root.name
  type         = "A"
  ttl          = 60

  rrdatas = [var.ip_address]
}

resource "google_dns_record_set" "a-test-sub" {
  name         = "test.${google_dns_managed_zone.root.dns_name}"
  managed_zone = google_dns_managed_zone.root.name
  type         = "A"
  ttl          = 60

  rrdatas = [var.ip_address]
}