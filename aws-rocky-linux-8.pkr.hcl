packer {
  required_plugins {
    amazon = {
      version = ">= 1.2.8"
      source  = "github.com/hashicorp/amazon"
    }
  }

  required_plugins {
    puppet = {
      version = ">= 1.0.0"
      source = "github.com/hashicorp/puppet"
    }
  }

}

source "amazon-ebs" "rocky_linux_8" {
  ami_name      = "apache-ebs-puppet"
  ami_description = "My custom AMI"
  instance_type = "t2.medium"
  region        = "us-east-1"
  source_ami_filter {
    filters = {
      name                = "Rocky-8-EC2-Base-8.9-20231119.0.x86_64-d6577ceb-8ea8-4e0e-84c6-f098fc302e82"

      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["679593333241"]
  }
  ssh_username = "rocky"
  tags = {
    Name = "rocky8-with-packer-python"
    OS = "Rocky Linux 8"
    Puppet_Provisioned = "true"
  }

  launch_block_device_mappings {
    device_name = "/dev/sda1" 
    volume_size = 10 # Size in GB
    volume_type = "gp3"
    delete_on_termination = true
  }

  launch_block_device_mappings {
    device_name = "/dev/xvdf" # Adjust if needed based on OS
    volume_type = "gp3"
    volume_size = 10 # Size in GB
    delete_on_termination = true
  }

}

build {
  sources = [
    "source.amazon-ebs.rocky_linux_8"
  ]

  provisioner "shell" {
    inline = [
      "sudo sed -i 's/^SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config",
      "sudo sed -i 's/^SELINUX=permissive/SELINUX=disabled/' /etc/selinux/config",
    ]
  }

  provisioner "shell" {
    inline = [
      "sudo dnf update -y", 
      "sudo dnf install -y https://yum.puppet.com/puppet7-release-el-8.noarch.rpm",
      "sudo dnf groupinstall \"Development Tools\" -y",
      "sudo dnf install -y puppet-agent",
      "sudo dnf install -y httpd",
      "sudo mkdir -p /mnt/ebs",
      "sudo mkfs.ext4 -t ext4 /dev/xvdf",
      "sudo mount /dev/xvdf /mnt/ebs",
      "sudo chown apache:apache /mnt/ebs",
      "sudo chmod -R 0755 /mnt/ebs",
      "sudo systemctl enable httpd",
      "sudo systemctl start httpd",
    ]
  }

  provisioner "puppet-masterless" {
    manifest_file = "manifests/site.pp"
    module_paths = ["${path.root}/modules"]
    puppet_bin_dir = "/opt/puppetlabs/bin"
  }
}