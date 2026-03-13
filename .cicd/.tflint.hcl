config {
  call_module_type = "all"
  force            = false
  plugin_dir       = "~/.tflint.d/plugins"
}


plugin "terraform" {
  enabled = true
  preset  = "recommended"
}

plugin "aws" {
  enabled = true
  version = "0.44.0"
  source  = "github.com/terraform-linters/tflint-ruleset-aws"
}

plugin "google" {
    enabled = true
    version = "0.37.1"
    source  = "github.com/terraform-linters/tflint-ruleset-google"
}


rule "terraform_naming_convention" {
  enabled = true
}

rule "terraform_documented_outputs" {
  enabled = true
}

rule "terraform_documented_variables" {
  enabled = true
}
