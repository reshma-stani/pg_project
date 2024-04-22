provider "google" {
  project = "cellular-tide-420012"
  region  = "us-central1"
}

resource "google_container_cluster" "my_cluster" {
  name     = "my-cluster"
  location = "us-central1"

  node_pool {
    name       = "default-pool"
    machine_type = "e2-medium"
    disk_size_gb = 10
    disk_type = "pd-standard"
    min_count = 1
    max_count = 3
    node_count = 1
  }
}
