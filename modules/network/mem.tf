resource "aws_elasticache_subnet_group" "wp-mem" {
  name       = "${var.environment}-wordpress-cache"
  subnet_ids = aws_subnet.private.*.id
}

resource "aws_elasticache_parameter_group" "default" {
  name   = "${var.environment}-memcached-params"
  family = "memcached1.6"
}

resource "aws_elasticache_cluster" "mem" {
  cluster_id           = "${var.environment}-wordpress-cache"
  engine               = "memcached"
  node_type            = "cache.t2.micro"
  num_cache_nodes      = 2
  parameter_group_name = "${var.environment}-memcached-params"
  port                 = 11211
  subnet_group_name    = aws_elasticache_subnet_group.wp-mem.name
  security_group_ids   = [aws_security_group.memcached.id]
}