# Required variables
variable "aws_key" {}
variable "domain" {}
variable "ssh-private-key" {}
variable "vpc_id" {}
variable "vpc_subnet_id" {}
variable "admin_email" {}
variable "admin_password" {}

# Optional variables to override in using the module
variable "ami" {
  default = {
    us-east-1 = "ami-7b386c11"
  }
}
variable "region" {
  default = "us-east-1"
}
variable "instance-type" {
  default = "m3.medium"
}
variable "rocketchat_user" {
  default="hubot"
}
variable "rocketchat_password" {
  default="hubotisawesome"
}

output "host" {
  value = "${aws_instance.chat.public_ip}"
}
output "domain" {
  value = "${var.domain}"
}
resource "aws_security_group" "chat" {
  name = "chat"
  vpc_id = "${var.vpc_id}"
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 3000
    to_port = 3000
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 3001
    to_port = 3001
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "template_file" "docker_compose" {
  template = "${file("${path.module}/docker-compose-yml.tpl")}"
  vars {
    root_url = "http://${var.domain}:3000"
    rocketchat_user = "${var.rocketchat_user}"
    rocketchat_password = "${var.rocketchat_password}"
    admin_email = "${var.admin_email}"
    admin_password= "${var.admin_password}"
  }
}
resource "aws_instance" "chat" {
  instance_type = "m3.medium"
  ami           = "ami-60b6c60a"
  key_name      = "${var.aws_key}"
  subnet_id        = "${var.vpc_subnet_id}"
  vpc_security_group_ids = [
    "${aws_security_group.chat.id}"
  ]
  tags {
    Name = "chat"
  }

  provisioner "remote-exec" {
    inline = [
      "echo \"${template_file.docker_compose.rendered}\" > ~/docker-compose.yml"
    ]

    connection {
      host = "${aws_instance.chat.public_dns}"
      type = "ssh"
      user = "ec2-user"
      port = 22
      key_file = "${var.ssh-private-key}"
    }
  }

  provisioner "remote-exec" {
    scripts = [
      "${path.module}/docker-install-chat.sh"
    ]

    connection {
      host = "${aws_instance.chat.public_dns}"
      type = "ssh"
      user = "ec2-user"
      port = 22
      key_file = "${var.ssh-private-key}"
    }
  }
}
