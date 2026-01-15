resource "aws_iam_openid_connect_provider" "default" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = ["sts.amazonaws.com"]
  # AWS auto-assigns this... If not provided here, it will appear as a diff for every plan/apply.
  thumbprint_list = ["2b18947a6a9fc7764fd8b5fb18a863b0c6dac24f"]

  tags = local.default_tags
}
