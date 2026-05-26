output "id" {
  description = "ID of the ElastiCache subnet group"
  value       = try(aws_elasticache_subnet_group.this[0].id, null)
}

output "name" {
  description = "Name of the ElastiCache subnet group"
  value       = try(aws_elasticache_subnet_group.this[0].name, null)
}
