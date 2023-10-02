resource "local_file" "ansible_inventory" {
  filename        = "../ansible/inventory.ini"
  file_permission = 0644
  content = templatefile("./inventory.tftpl",
    {
      app_private_ip_list  = aws_network_interface.eni-app[*].private_ip
      app_instance_id_list = aws_instance.app[*].id
      iscsi_node_ip        = aws_network_interface.eni-iscsi.private_ip
      lb_private_ip_list   = aws_network_interface.eni-lb[*].private_ip
      lb_instance_id_list  = aws_instance.lb[*].id
      db_private_ip_list   = aws_network_interface.eni-db[*].private_ip
      db_instance_id_list  = aws_instance.db[*].id
    }
  )
}
