resource "aws_route53_record" "rds" {
  name    = var.db_dns_name
  zone_id = data.terraform_remote_state.route53.outputs.dns_zone_id
  type    = "CNAME"
  records = [module.rds.db_instance_address]
  ttl     = 60
  provisioner "local-exec" {
    command = "until nslookup ${self.name} 2> /dev/null; do echo 'Wait until the DNS name is resolvable'; sleep 5; done"
  }
}
