resource "aws_db_instance" "postgres" {
    
    allocated_storage = 10
    instance_class = "db.t3.micro"
    engine = "postgres"
    username = "djangouser"
    engine_version = "15"
    db_name = "postgres"
    port = 5432
    password = var.db_password

    vpc_security_group_ids = [aws_security_group.db_sg.id]
    db_subnet_group_name=aws_db_subnet_group.db_subnet_group.name
    multi_az = true
    publicly_accessible = false
    final_snapshot_identifier = true
}

resource "aws_db_subnet_group" "db_subnet_group" {
  
    name= "${local.env}-db-subnet-group"
    subnet_ids = [aws_subnet.private_zone1.id, 
    aws_subnet.private_zone2.id]

    tags = {
      "Name" = "${local.env}-db-subnet-group"
    }
}


resource "aws_security_group" "db_sg" {
  name = "${local.env}-db-sec-group"
  vpc_id = aws_vpc.szakd-vpc.id

  ingress {

    from_port = 5432
    to_port = 5432
    protocol = "tcp"
    cidr_blocks = [aws_subnet.private_zone1.cidr_block, 
    aws_subnet.private_zone2.cidr_block]
  }

}