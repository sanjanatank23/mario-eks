# module "eks" {
#   source = "./modules/eks"

#   vpc_id      = module.vpc.vpc_id
#   subnet_ids  = module.vpc.subnet_ids
#   public_subnet_ids = module.vpc.public_subnet_ids

#   desired_size       = var.desired_size
#   max_size           = var.max_size
#   min_size           = var.min_size
#   node_instance_type = var.node_instance_type
# }

module "eks" {
  source = "./modules/eks"

  vpc_id             = module.vpc.vpc_id
  subnet_ids         = module.vpc.subnet_ids
  public_subnet_ids  = module.vpc.subnet_ids
  node_role_arn      = module.iam.node_role_arn
}



# module "vpc" {
#   source = "./modules/vpc"

#   cidr_block           = var.vpc_cidr
#   public_subnet_cidrs  = var.public_subnet_cidrs
# }

module "iam" {
  source = "./modules/iam"
}
module "vpc" {
  source = "./modules/vpc"

  vpc_cidr = var.vpc_cidr

  public_subnet_cidrs = var.public_subnet_cidrs
}

# module "eks" {
#   source = "./modules/eks"

#   subnet_ids    = module.vpc.subnet_ids
#   node_role_arn = module.iam.node_role_arn
# }
