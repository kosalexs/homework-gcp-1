resource "google_compute_instance" "app" {
  name         = "reddit-app"
  machine_type = "g1-small"
  zone         = "${var.zone}"
  tags         = ["reddit-app"]

  boot_disk {
    initialize_params {
      image = "${var.app_disk_image}"
    }
  }

  network_interface {
    network = "default"

    access_config = {
      nat_ip = "${google_compute_address.app_ip.address}"
    }
  }

  metadata {
    ssh-keys = "kalekseev:${file(var.public_key_path)}"
  }
  
  provisioner "file" {
    source      = "../modules/app/setup_app.sh"
    destination = "/home/kalekseev/setup_app.sh"
	
	connection {
      type        = "ssh"
      user        = "kalekseev"
      private_key = "${file("~/.ssh/kalekseev")}"
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/kalekseev/setup_app.sh",
	  "echo ${var.db_internal_ip} > ip.txt",
      "./setup_app.sh ${var.db_internal_ip} > log.txt",
    ]
	
    connection {
      type        = "ssh"
      user        = "kalekseev"
      private_key = "${file("~/.ssh/kalekseev")}"
    }
  }
}

resource "google_compute_address" "app_ip" {
  name = "reddit-app-ip"
}

resource "google_compute_firewall" "firewall_puma" {
  name    = "allow-puma-default"
  network = "default"

  allow {
    protocol = "tcp"

    ports = ["9292"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["reddit-app"]
}
