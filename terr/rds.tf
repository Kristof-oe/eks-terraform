resource "aws_db_instance" "postgres" {

  allocated_storage = var.allocated_storage
  instance_class    = var.instance_class
  engine            = var.engine
  username          = var.username
  engine_version    = var.engine_version
  db_name           = var.db_name
  port              = var.port
  password          = var.db_password

  vpc_security_group_ids = [aws_security_group.db_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
  multi_az               = var.multi_az
  publicly_accessible    = var.publicly_accessible
  skip_final_snapshot    = var.skip_final_snapshot
}

resource "aws_db_subnet_group" "db_subnet_group" {

  name = "${local.env}-db-subnet-group"
  subnet_ids = [aws_subnet.private_subnet1.id,
  aws_subnet.private_subnet2.id]

  tags = {
    "Name" = "${local.env}-db-subnet-group"
  }
}


resource "aws_security_group" "db_sg" {
  name   = "${local.env}-db-sec-group"
  vpc_id = aws_vpc.main.id

  ingress {

    from_port = var.port
    to_port   = var.port
    protocol  = var.protocol
    cidr_blocks = [aws_subnet.private_subnet1.cidr_block,
    aws_subnet.private_subnet2.cidr_block]
  }

}