output "regions" {
  value = local.regions
  description = "Region information."
}

output "top_level_domain" {
  value = local.regions_top_level_domain
  description = "Top Level Domain to use for resources across all regions."
}