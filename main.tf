data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_key_pair" "terraform_key" {
  key_name   = "terraform-key"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_instance" "ec2_instance" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.medium"
  vpc_security_group_ids = [aws_security_group.main_sg.id]
  key_name               = aws_key_pair.terraform_key.id
  subnet_id              = aws_subnet.public_subnet.id
  depends_on = [
    aws_db_instance.db["appdb"],
  ]

  tags = {
    Name = "webserver"
  }

  # This provisioner will get the instance public dns and save its output into the inventory file, 
  # which will be used as an inventory file by Ansible.
  # It will wait for 120 secs, making sure the instance is ready for SSH connections and Ansible will run the playbook.yml,
  # which will install docker-ce, packages dependencies, clone git repo, build the image and run the container.
  provisioner "local-exec" {
    command = "echo ${aws_instance.ec2_instance.public_dns} > inventory; sleep 120; ansible-playbook -i inventory playbook.yml"
  }
}

