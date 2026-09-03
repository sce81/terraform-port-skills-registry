terraform {
  required_providers {
    port = {
      source  = "port-labs/port-labs"
      version = "~> 2.4"
    }
    http = {
      source  = "hashicorp/http"
      version = "~> 3.5"
    }
  }
}
