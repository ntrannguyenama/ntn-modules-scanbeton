locals {
    web_app = {
    #  sku_name = var.web_app.sku_name != null ? var.web_app.sku_name : "B1"
    #  os_type = var.web_app.os_type != null ? var.web_app.os_type : "Linux"
     node_version = var.web_app.node_version != null ? var.web_app.node_version : "18-lts"
     app_command_line = var.web_app.app_command_line != null ? var.web_app.app_command_line : "#"
    #  worker_count = var.web_app.worker_count != null ? var.web_app.worker_count : 1
     allowed_origins = var.web_app.allowed_origins != null ? var.web_app.allowed_origins : ["*"]
     support_credentials = var.web_app.support_credentials != null ? var.web_app.support_credentials : false
    }
 
     base_tags = {
         Environment = var.environment
         Application = var.app_name
         Terraform   = "true"
         ManagedBy   = "terraform"
     }
   
     merged_tags = merge(local.base_tags, var.tags)
 }