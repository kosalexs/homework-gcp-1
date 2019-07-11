output "db_internal_ip" {
  value = "${google_compute_instance.db.0.network_interface.0.network_ip}"
}
