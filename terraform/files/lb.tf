resource "google_compute_instance_group" "puma-servers" {
  name        = "puma-webservers"
  description = "Terraform test puma instance group"

  instances = [
    "${google_compute_instance.app.*.self_link}",
  ]

  named_port {
    name = "http"
    port = "9292"
  }

  zone = "europe-west1-b"
}

resource "google_compute_global_forwarding_rule" "default" {
  name       = "global-rule"
  target     = "${google_compute_target_http_proxy.default.self_link}"
  port_range = "80"
}

resource "google_compute_target_http_proxy" "default" {
  name        = "target-proxy"
  description = "LB Target Proxy Test"
  url_map     = "${google_compute_url_map.default.self_link}"
}

resource "google_compute_url_map" "default" {
  name            = "url-map-target-proxy"
  description     = "LB ULR MAP TEST"
  default_service = "${google_compute_backend_service.puma-server.self_link}"

  host_rule {
    hosts        = ["130.211.8.53"]
    path_matcher = "allpaths"
  }

  path_matcher {
    name            = "allpaths"
    default_service = "${google_compute_backend_service.puma-server.self_link}"

    path_rule {
      paths   = ["/*"]
      service = "${google_compute_backend_service.puma-server.self_link}"
    }
  }
}

resource "google_compute_backend_service" "puma-server" {
  project          = "test-project-1-244707"
  name             = "test-backend-service"
  protocol         = "http"
  timeout_sec      = 10
  session_affinity = "NONE"

  backend = [
    {
      group = "${google_compute_instance_group.puma-servers.self_link}"
    },
  ]

  health_checks = ["${google_compute_health_check.http.self_link}"]
}

resource "google_compute_health_check" "http" {
  count   = "1"
  project = "test-project-1-244707"
  name    = "puma-test-hc"

  http_health_check {
    port = "9292"
  }
}

resource "google_compute_firewall" "default-lb-fw" {
  project = "test-project-1-244707"
  name    = "default-lb-fw"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["9292"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["puma-server"]
}
