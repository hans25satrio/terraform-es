resource "aws_key_pair" "terraform_ec2_key" {
  key_name   = "hans-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDOs2LHTyc9xjU+9Lxb6itOu3dJCbKfPCvqjEyVs/ZyZN1t8KlJB+pnlhc+DBoxIAw1rguK6wt/HmDeA1HhXNUTYtT/k/9iopYtpTXakK4j3cQ+VRxlL7Z44mf7GcREMWmBjEslFuzMU7yLoIhvQf+ciI5VJ+NQJh3eiHx2lZsjXewd5pHSH7AcnEHVMWcYTHZ0ejv1rE03anzLj2/HLkeT0Q3dpDsIZ2S3gLUgrIXtDex5YFb/AqQp0D+esSFPapeyv5td027nN26ly2DxKB47b1WxYcHW8KaoQ+I1kfmPWxcRgMHW3HgJBnrJpK+BJXVX7RaVx9S6oh5EIv2PptNVx+8PnzhTUDTLtNLtFdpslFx3fmdEjQWdW69iGUq9g3ShALl6AEmMABzxiSU4XCZXfCmF58qdUSUa3uWk+I9fTY7T08rh80jfgrt8c/m985fbv3YH9L7vjuHip804pZB0xYJXsJqeYQK1wr9w8TK+44Ef4YatndxAa8Y9Cx6WPOLjq2R4vtBOT29VxGCzES5nNM5HQ1bBbG7waLr5QZQkffWD4221ilDd0Cw1FgAHarksuMrWCkbh4dzMaONTUmbYuwkS8nzNW4YW9ZdD40jwlmvUuLL5bRNRO6Z0haLoxkw/flNzBHVeFOaqmcEw7GdO77MdtmtOtwrQ2MF0eHesCQ== hans25satrio@gmail.com"
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
    host        = "aws_instance.hans-es.public_ip"
    user        = "ubuntu"
    private_key = file("pem/hans-key.pem")

  }

  provisioner "remote-exec" {
    inline = [
      "mkdir /home/ubuntu/docker-needs",
    ]
  }
  provisioner "file" {
    source      = "../install-docker.sh"
    destination = "/home/ubuntu"
  }
  provisioner "file" {
    source      = "../elasticsearch.yml"
    destination = "/home/ubuntu/docker-needs"
  }
  provisioner "file" {
    source      = "../Dockerfile-elastic"
    destination = "/home/ubuntu/docker-needs"
  }
  provisioner "file" {
    source      = "../docker-compose-elastic"
    destination = "/home/ubuntu/docker-needs"
  }
  provisioner "file" {
    source      = "../docker-entrypoint.sh"
    destination = "/home/ubuntu/docker-needs"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/ubuntu/install-docker.sh",
      "/bin/sh -c /home/ubuntu/install-docker.sh",
      "cd docker-needs"
      "docker-compose -f docker-compose-elastic.yml up"
    ]
  }

}
