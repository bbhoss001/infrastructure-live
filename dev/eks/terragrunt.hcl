terraform {
    source = "git::https://github.com/bbhoss001/infrastructure-modules.git//eks?ref=main"
}

include "root" {
  path = find_in_parent_folders()
}

include "env" {
  path = find_in_parent_folders("env.hcl")
  expose = true 
  merge_strategy = "no_merge"
}

inputs = {
    eks_version = "1.30"
    env = include.env.locals.env 
    eks_name = "demo"
    subnet_ids = dependency.vpc.outputs.private_subnets_ids

    node_groups = {
        general = {
            capacity_type = "ON_DEMAND"
            instance_types = ["t3a.xlarge"]
            scaling_config = {
                desired_size = 1
                max_size = 10
                min_size = 0
            }
        }
    }
    }
dependency "vpc" {
    config_path = "../vpc"
    mock_outputs = {
        private_subnets_ids = ["subnet-1234", "subnet-5678"]
    }
}