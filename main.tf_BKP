provider "google" {
  project = "cellular-tide-420012"
  region  = "us-central1"
}

resource "google_container_cluster" "my_cluster" {
  name     = "my-cluster"
  location = "us-central1"

  node_config {
    machine_type = "e2-medium"
    disk_size_gb = 10
    disk_type    = "pd-standard"
  }

  node_pool {
    name       = "default-pool"
    initial_node_count = 1
    autoscaling {
      min_node_count = 1
      max_node_count = 3
    }
  }
}

