output "ip_address" {
  value = jsondecode(azapi_resource.nginx-deployment.output).properties.ipAddress
}

output "nginx_version" {
  value = jsondecode(azapi_resource.nginx-deployment.output).properties.nginxVersion
}