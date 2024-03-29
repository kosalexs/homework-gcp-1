provider "google" {
  version = "2.0.0"
  project = "${var.project}"
  region  = "${var.region}"
}

module "db" {
  source          = "../modules/db"
  public_key_path = "${var.public_key_path}"
  zone            = "${var.zone}"
  db_disk_image   = "${var.db_disk_image}"
}

module "app" {
  source          = "../modules/app"
  public_key_path = "${var.public_key_path}"
  zone            = "${var.zone}"
  app_disk_image  = "${var.app_disk_image}"
  db_internal_ip  = "${module.db.db_internal_ip}"
}

module "vpc" {
  source          = "../modules/vpc"
  public_key_path = "${var.public_key_path}"
  zone            = "${var.zone}"
  disk_image      = "${var.disk_image}"
  source_ranges   = ["0.0.0.0/0"]
}
