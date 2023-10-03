resource "aws_network_interface_sg_attachment" "sg_attachment" {
  count                = var.lb_count
  network_interface_id = aws_network_interface.eni-lb[count.index].id
  security_group_id    = "sg-3F164544"
}
