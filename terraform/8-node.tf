resource "aws_iam_role" "szakd-node" {
  name= "${local.env}-${local.eks_name}-eks-node"
  assume_role_policy = <<POLICY
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "ec2.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  }
POLICY
}

resource "aws_iam_role_policy_attachment" "amazon_eks_worker_node_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role = aws_iam_role.szakd-node.name
  
}

resource "aws_iam_role_policy_attachment" "amazon_eks_worker_cni_policy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
    role = aws_iam_role.szakd-node.name
  
}

resource "aws_iam_role_policy_attachment" "amazon_ec2_container_registry_read_only" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
    role = aws_iam_role.szakd-node.name

}


resource "aws_eks_node_group" "general" {
    cluster_name = aws_eks_cluster.szakd-eks.name
    version = local.eks_version
    node_group_name = "worker-node"
    node_role_arn = aws_iam_role.szakd-node.arn

    subnet_ids = [

        aws_subnet.private_zone1.id,
        aws_subnet.private_zone2.id,
    ]

    capacity_type = "ON_DEMAND"
    instance_types = ["t3.small"]


    scaling_config {
        desired_size = 2
        max_size = 3
        min_size = 1
    }

    update_config {
      max_unavailable = 1
    }

    labels ={
        role = "general"
    } 

    depends_on = [ 
        aws_iam_role_policy_attachment.amazon_eks_worker_cni_policy,
        aws_iam_role_policy_attachment.amazon_eks_worker_node_policy,
        aws_iam_role_policy_attachment.amazon_ec2_container_registry_read_only,
     ]

     lifecycle {
       ignore_changes = [ scaling_config[0].desired_size ]
     }
}

