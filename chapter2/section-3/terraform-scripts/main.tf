// Create RDS PSQL
module "db" {
  source = "terraform-aws-modules/rds/aws"
  identifier = var.db_name
  engine            = "postgres"
  engine_version    = "9.6.9"
  instance_class    = var.db_instance_type
  allocated_storage = 5
  storage_encrypted = false
  publicly_accessible = true
  name = var.db_name
  username = var.db_user
  password = var.db_password
  port     = "5432"
  vpc_security_group_ids = [data.aws_security_group.default.id]
  backup_retention_period = 0
  tags = var.tags

  # DB subnet group
  subnet_ids = data.aws_subnet_ids.all.ids

  # DB parameter group
  family = var.postgres_version

  # DB option group
  major_engine_version = "9.6"

  # Database Deletion Protection
  deletion_protection = false
  backup_window      = "03:00-06:00"
  maintenance_window = "Mon:00:00-Mon:03:00"
}


// Create EC2 instance to execute the code
resource "aws_instance" "application-instance" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  tags = var.tags
  key_name = var.auth_key_name
}

resource "aws_security_group_rule" "allow_myip_psql" {
  type            = "ingress"
  from_port       = 5432
  to_port         = 5432
  protocol        = "tcp"
  cidr_blocks = [format("%s/32", data.external.script.result["myip"])]
  security_group_id = data.aws_security_group.default.id
}

resource "aws_security_group_rule" "allow_myip_ssh" {
  type            = "ingress"
  from_port       = 22
  to_port         = 22
  protocol        = "tcp"
  cidr_blocks = [format("%s/32", data.external.script.result["myip"])]
  security_group_id = data.aws_security_group.default.id
}


