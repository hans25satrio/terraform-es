resource "aws_key_pair" "terraform_ec2_key" {
  key_name   = "hans-key"
  public_key = "{Add your public RSA here}"
}

resource "aws_instance" "hans-es" {
  ami                         = "ami-04763b3055de4860b" #ubuntu16
  instance_type               = "t2.micro"
  private_ip                  = "172.28.0.6"
  associate_public_ip_address = "true"
  subnet_id                   = aws_subnet.publicES.id
  vpc_security_group_ids      = ["${aws_security_group.hansessg.id}"]
  key_name                    = "hans-key"
  tags = {
    Name = "Hans ES"
  }
  connection {
    type        = "ssh"
    host        = aws_instance.hans-es.public_ip
    user        = "ubuntu"
    private_key = file("pem/hans-key")

  }

  provisioner "remote-exec" {
    inline = [
      "mkdir /home/ubuntu/docker-needs",
      "mkdir /home/ubuntu/certs"
    ]
  }
  provisioner "file" {
    source      = "../install-docker.sh"
    destination = "/home/ubuntu/install-docker.sh"
  }
  provisioner "file" {
    source      = "../certs/elastic-certificates.p12"
    destination = "/home/ubuntu/certs/elastic-certificates.p12"
  }
  provisioner "file" {
    source      = "../elasticsearch.yml"
    destination = "/home/ubuntu/docker-needs/elasticsearch.yml"
  }
  provisioner "file" {
    source      = "../Dockerfile-elastic"
    destination = "/home/ubuntu/docker-needs/Dockerfile-elastic"
  }
  provisioner "file" {
    source      = "../docker-compose-elastic.yml"
    destination = "/home/ubuntu/docker-needs/docker-compose-elastic.yml"
  }
  provisioner "file" {
    source      = "../docker-entrypoint.sh"
    destination = "/home/ubuntu/docker-needs/docker-entrypoint.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/ubuntu/install-docker.sh",
      "sudo chmod +x /home/ubuntu/certs/elastic-certificates.p12",
      "/bin/sh -c /home/ubuntu/install-docker.sh",
      "cd docker-needs",
      "sudo docker-compose -f docker-compose-elastic.yml up --build -d"
    ]
  }

}
