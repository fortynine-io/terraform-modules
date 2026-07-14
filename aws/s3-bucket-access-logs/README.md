# `aws/s3-bucket-access-logs`

_TODO: Add Terraform module overview..._

## Design Notes

_TODO: Add any relevant design notes here..._

## References

_TODO: Add relevant reference links here..._

## Example Usage

_A complete example can be found in the [{{ cookiecutter.module_name }}/example](/example) directory._

```hcl
module "s3_bucket_access_logs" {
  source = "git::https://github.com/fortynine-io/terraform-modules.git//aws/eks-addon?ref=aws/eks-addon/v0.1.1"

  # Implement required module configuration here...

  tags = local.default_tags
}
```

## Changelog

_A complete Changelog history can be found in [{{ cookiecutter.module_name }}/CHANGELOG.md](CHANGELOG.md)._

## Provider Requirements

_All provider requirements can be found in [{{ cookiecutter.module_name }}/versions.tf](versions.tf)._

## Input Variables

_All variable details can be found in [{{ cookiecutter.module_name }}/variables.tf](variables.tf)._

| Variable Name | Description                                                                                           |
|---------------|-------------------------------------------------------------------------------------------------------|
| `tags`        | (Optional) Key-value map of resource tags to be applied to all taggable resources within this module. |

## Outputs

_All output details can be found in [{{ cookiecutter.module_name }}/outputs.tf](outputs.tf)._

| Variable Name       | Description       |
| -------------       | -----------       |
