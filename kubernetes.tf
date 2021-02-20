terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "flask_deployment" "flask" {
  metadata {
    name = "flaskapp-deployment"
    labels = {
      App = "flaskapp"
    }
  }

  spec {
    replicas = 2
    selector {
      match_labels = {
        App = "flaskapp"
      }
    }
    template {
      metadata {
        labels = {
          App = "flaskapp"
        }
      }
      spec {
        container {
          image = "karinegh18/casestudy:latest"
          name  = "flaskappC"

          port {
            container_port = 8080
          }
        }
      }
    }
  }
}
resource "flask_service" "flask" {
  metadata {
    name = "flask-service"
  }
  spec {
    selector = {
      App = flaskapp
    }
    port {
      node_port   = 30201
      port        = 8080
      target_port = 8080
    }

    type = "NodePort"
  }
}