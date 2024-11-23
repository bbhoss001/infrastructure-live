remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt" ## terragrunt will overwrite the file if it exists already
  }
  config = {
    profile = "devops"
    role_arn = "arn:aws:iam::672451395673:role/terraform"
    bucket = "terraform-terragrunt-08042000"
    key = "${path_relative_to_include()}/terraform.tfstate"
    region         = "us-east-1"
    encrypt = true 
  }
}

generate "provider" {
  path = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
provider "aws" {
  region = "us-east-1"
  profile = "devops"
  assume_role {
    session_name = "lesson-160"
    role_arn = "arn:aws:iam::672451395673:role/terraform"
    }
}
EOF
}