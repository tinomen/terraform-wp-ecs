resource "aws_efs_file_system" "wordpress" {
  creation_token = "${var.environment}-wordpress"
  encrypted      = true
  kms_key_id     = aws_kms_key.wordpress.arn
}

resource "aws_efs_mount_target" "wordpress" {
  count           = length(aws_subnet.public)
  file_system_id   = aws_efs_file_system.wordpress.id
  subnet_id       = aws_subnet.public[count.index].id
  security_groups = [aws_security_group.efs_service.id]
}
resource "aws_efs_access_point" "wordpress_root" {
  file_system_id = aws_efs_file_system.wordpress.id
  posix_user {
    gid = 33
    uid = 33
  }
  root_directory {
    path = "/bitnami"
    creation_info {
      owner_gid   = 33
      owner_uid   = 33
      permissions = 755
    }
  }
}