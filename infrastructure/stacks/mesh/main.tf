resource "aws_appmesh_mesh" "uec-dos-cs-api-mesh" {
  name = var.mesh_name

  spec {
    egress_filter {
      type = "DROP_ALL"
    }
  }

  tags = {
    Name        = var.service_prefix
    BillingCode = var.billing_code_tag
    Environment = var.environment_tag
    Version     = var.version_tag
    Service     = var.service_name
  }

}

resource "aws_appmesh_virtual_gateway" "gateway" {
  name      = "virtual-gateway"
  mesh_name = aws_appmesh_mesh.uec-dos-cs-api-mesh.id

  spec {
    listener {
      port_mapping {
        port     = 443
        protocol = "http"
      }
    }
  }

  tags = {
    Name        = var.service_prefix
    BillingCode = var.billing_code_tag
    Environment = var.environment_tag
    Version     = var.version_tag
    Service     = var.service_name
  }

}

resource "aws_appmesh_virtual_service" "service" {
  name      = "service"
  mesh_name = aws_appmesh_mesh.uec-dos-cs-api-mesh.id

  spec {
    provider {
      virtual_node {
        virtual_node_name = aws_appmesh_virtual_node.node.name
      }
    }
  }

  tags = {
    Name        = var.service_prefix
    BillingCode = var.billing_code_tag
    Environment = var.environment_tag
    Version     = var.version_tag
    Service     = var.service_name
  }
}

resource "aws_appmesh_virtual_node" "node" {
  name      = "node"
  mesh_name = aws_appmesh_mesh.uec-dos-cs-api-mesh.id

  spec {
    backend {
      virtual_service {
        virtual_service_name = "service"
      }
    }

    listener {
      port_mapping {
        port     = 443
        protocol = "http"
      }
    }

    service_discovery {
      dns {
        hostname = "service"
      }
    }
  }

  tags = {
    Name        = var.service_prefix
    BillingCode = var.billing_code_tag
    Environment = var.environment_tag
    Version     = var.version_tag
    Service     = var.service_name
  }
}

resource "aws_appmesh_virtual_router" "router" {
  name      = "router"
  mesh_name = aws_appmesh_mesh.uec-dos-cs-api-mesh.id

  spec {
    listener {
      port_mapping {
        port     = 443
        protocol = "http"
      }
    }
  }

  tags = {
    Name        = var.service_prefix
    BillingCode = var.billing_code_tag
    Environment = var.environment_tag
    Version     = var.version_tag
    Service     = var.service_name
  }
}

resource "aws_appmesh_route" "route" {
  name                = "route"
  mesh_name           = aws_appmesh_mesh.uec-dos-cs-api-mesh.id
  virtual_router_name = aws_appmesh_virtual_router.router.name

  spec {
    http_route {
      match {
        prefix = "/"
      }

      action {
        weighted_target {
          virtual_node = aws_appmesh_virtual_node.node.name
          weight       = 100
        }
      }
    }
  }

  tags = {
    Name        = var.service_prefix
    BillingCode = var.billing_code_tag
    Environment = var.environment_tag
    Version     = var.version_tag
    Service     = var.service_name
  }
}
