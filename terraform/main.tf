resource "aws_network_interface" "eni-app" {
  count     = 2
  subnet_id = var.subnet[count.index]

  tags = {
    Name = "primary network interface for eni-app-${count.index}"
  }
}

resource "aws_instance" "app" {
  count         = 2
  ami           = "cmi-5DB160EF"
  instance_type = "c5.large"

  tags = {
    Name = "app${count.index}"
  }

  network_interface {
    network_interface_id = aws_network_interface.eni-app[count.index].id
    device_index         = 0
  }


  root_block_device {
    volume_size = 32
    volume_type = "gp2"
    tags = {
      "Name" = "Disk for app${count.index}"
    }

  }

  key_name = "AGlumov"

}

resource "aws_ebs_volume" "iscsi_vol" {
  availability_zone = "ru-msk-vol52"
  size              = 32
  type              = "gp2"

  tags = {
    Name = "Disk for Pacemaker cluster"
  }

}

resource "aws_volume_attachment" "iscsi_vol_attach" {
  device_name = "disk2"
  volume_id   = aws_ebs_volume.iscsi_vol.id
  instance_id = aws_instance.iscsi.id
}

resource "aws_network_interface" "eni-iscsi" {
  subnet_id = "subnet-05E8BE02"

  tags = {
    Name = "primary network interface for eni-iscsi"
  }
}

resource "aws_instance" "iscsi" {
  ami           = "cmi-5DB160EF"
  instance_type = "c5.large"

  tags = {
    Name = "iscsi target"
  }

  network_interface {
    network_interface_id = aws_network_interface.eni-iscsi.id
    device_index         = 0
  }

  root_block_device {
    volume_size = 32
    volume_type = "gp2"
    tags = {
      "Name" = "Disk for iscsi instance"
    }

  }

  key_name = "AGlumov"

}

resource "aws_network_interface" "eni-lb" {
  count     = var.lb_count
  subnet_id = var.subnet[count.index]

  tags = {
    Name = "primary network interface for eni-lb-${count.index}"
  }
}

resource "aws_instance" "lb" {
  count         = var.lb_count
  ami           = "cmi-5DB160EF"
  instance_type = "c5.large"

  tags = {
    Name = "lb${count.index}"
  }

  network_interface {
    network_interface_id = aws_network_interface.eni-lb[count.index].id
    device_index         = 0
  }


  root_block_device {
    volume_size = 32
    volume_type = "gp2"
    tags = {
      "Name" = "Disk for lb${count.index}"
    }

  }

  key_name = "AGlumov"

}

resource "aws_network_interface" "eni-db" {
  count     = 1
  subnet_id = var.subnet[count.index]

  tags = {
    Name = "primary network interface for eni-db-${count.index}"
  }
}

resource "aws_instance" "db" {
  count         = 1
  ami           = "cmi-5DB160EF"
  instance_type = "c5.large"

  tags = {
    Name = "db${count.index}"
  }

  network_interface {
    network_interface_id = aws_network_interface.eni-db[count.index].id
    device_index         = 0
  }


  root_block_device {
    volume_size = 32
    volume_type = "gp2"
    tags = {
      "Name" = "Disk for db${count.index}"
    }

  }

  key_name = "AGlumov"

}
