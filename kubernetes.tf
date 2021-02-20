terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.0"
    }
    docker = {
      source = "kreuzwerker/docker"
      version = "2.11.0"
    }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}
provider "docker" {
  host = "tcp://localhost:2376"
}
resource "kubernetes_namespace" "test" {
  metadata {
    name = "flaskapp"
  }
}

resource "kubernetes_deployment" "flask" {
  metadata {
    name	= "flaskapp-deployment"
	namespace = kubernetes_namespace.test.metadata.0.name    
  
  
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
resource "kubernetes_service" "flask" {
  metadata {
    name	= "flask-service"
	namespace = kubernetes_namespace.test.metadata.0.name													 
  }
  spec {
    selector = {
      App = kubernetes_deployment.flask.spec.0.template.0.metadata.0.labels.App
    }
    port {
      node_port   = 30201
      port        = 8080
      target_port = 8080
    }

    type = "NodePort"
  }
}