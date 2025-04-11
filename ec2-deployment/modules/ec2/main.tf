# EC2 Instance
resource "aws_instance" "app" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]
  key_name              = var.ssh_key_name

  user_data = templatefile("${path.module}/templates/user_data.sh", {
    docker_image = var.docker_image
  })

  root_block_device {
    volume_size = 10
    volume_type = "gp2"
  }

  tags = {
    Name = "${var.environment}-instance"
  }
}
