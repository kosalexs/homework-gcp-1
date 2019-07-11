terraform {
  backend "gcs" {
    bucket  = "storage-kos-test1"
    prefix  = "terraform/prod-state"
  }
}