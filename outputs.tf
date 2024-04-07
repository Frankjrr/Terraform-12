// outputs ///////////////////
output "aws-ami_id" {
  value = module.myapp-webserver.aws-ami_id.id
}
output "ec2-public_ip" {
  value = module.myapp-webserver.ec2-public_ip.public_ip
}