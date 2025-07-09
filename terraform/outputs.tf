output "ec2_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.flask_app.public_ip
}

output "rds_endpoint" {
  description = "Endpoint of the RDS MySQL database"
  value       = aws_db_instance.task_db.endpoint
}
