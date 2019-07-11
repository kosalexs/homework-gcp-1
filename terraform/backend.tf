terraform {
  backend "gcs" {
    bucket  = "storage-kos-test1"
    prefix  = "terraform/state"
  }
}