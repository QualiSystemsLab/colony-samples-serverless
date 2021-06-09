resource "null_resource" "prevent_ext_data_refresh" {
  lifecycle {
    ignore_changes=all
  }
  provisioner "local-exec" {
    when    = create
    command = "echo ''"
    interpreter = ["/bin/bash", "-c"]
  }
}

locals {
  aws_region  = var.aws_region
  SANDBOX_ID  = var.SANDBOX_ID
  SLS_Repo    = var.SLS_Repo
  SLS_Version = var.SLS_Version
  SLS_Stage   = var.SLS_Stage
}

data "external" "run_sls" {
  program = [
    "bash",
    "run_sls.sh",
    local.aws_region,
    local.SANDBOX_ID,
    local.SLS_Repo,
    local.SLS_Version,
    local.SLS_Stage
  ]
  depends_on = [null_resource.prevent_ext_data_refresh]  # adding a dependency so it won't be executed at the plan phase (as part of refreshing state)
}

resource "null_resource" "delete_sls" {
  triggers = {
    SANDBOX_ID = local.SANDBOX_ID
    aws_region = local.aws_region
    SLS_Stage = local.SLS_Stage
    SLS_Repo = data.external.run_sls.result.SLS_Repo
  }
  provisioner "local-exec" {
    when        = destroy
    # working_dir = path.module
    on_failure  = fail
    interpreter = ["/bin/bash", "-c"]
    # command = "ls -la && pwd"
    command = "cd ${self.triggers.SLS_Repo} && ls -la && ls -la $HOME && $HOME/.serverless/bin/sls remove --region ${self.triggers.aws_region} --stage ${self.triggers.SLS_Stage}"
  }
}


output "URL"{ 
  value = data.external.run_sls.result.URL
}

output "SLS_SVC"{ 
  value = data.external.run_sls.result.SLS_SVC
}