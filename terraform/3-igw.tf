resource "aws_internet_gateway" "szakd_igw" {
    vpc_id = aws_vpc.szakd-vpc.id
    
    tags = {
        Name = "${local.env}-igw"
    }
  
}