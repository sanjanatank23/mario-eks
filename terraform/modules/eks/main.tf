################################
# EKS CLUSTER
################################
resource "aws_eks_cluster" "this" {
  name     = "mario-eks"
  role_arn = aws_iam_role.eks_role.arn

  vpc_config {
    subnet_ids = var.subnet_ids
  }
}

################################
# EKS CLUSTER IAM ROLE
################################
resource "aws_iam_role" "eks_role" {
  name = "mario-eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "eks.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eks_policy" {
  role       = aws_iam_role.eks_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

################################
# FARGATE POD EXECUTION ROLE
################################
resource "aws_iam_role" "fargate_role" {
  name = "mario-eks-fargate-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "eks-fargate-pods.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "fargate_policy" {
  role       = aws_iam_role.fargate_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
}

################################
# FARGATE PROFILE (ONLY kube-system)
################################
# resource "aws_eks_fargate_profile" "kube_system" {
#   cluster_name           = aws_eks_cluster.this.name
#   fargate_profile_name   = "kube-system"
#   pod_execution_role_arn = aws_iam_role.fargate_role.arn
#   subnet_ids             = var.subnet_ids

#   selector {
#     namespace = "kube-system"
#   }
# }
################################
# EC2 MANAGED NODE GROUP (FREE TIER SAFE)
################################
resource "aws_eks_node_group" "mario_nodegroup" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "mario-nodegroup"

 node_role_arn = var.node_role_arn

  subnet_ids     = var.subnet_ids

  scaling_config {
    desired_size = 1
    min_size     = 1
    max_size     = 1
  }

  instance_types = ["t3.small"]   # Free Tier eligible
  capacity_type  = "ON_DEMAND"

  ami_type = "AL2023_x86_64_STANDARD"

  labels = {
    role = "ec2"
  }

  tags = {
    Name = "mario-eks-worker"
  }
}
