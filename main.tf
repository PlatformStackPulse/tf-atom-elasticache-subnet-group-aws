resource "aws_elasticache_subnet_group" "this" {
  count = local.enabled ? 1 : 0

  name        = module.this.id
  description = coalesce(var.description, "ElastiCache subnet group for ${module.this.id}")
  subnet_ids  = var.subnet_ids

  tags = local.tags
}
