output "arn" {
  description = "EKS-managed add-on ARN."
  value       = aws_eks_addon.addon.arn
}

output "created_at" {
  description = "EKS-managed add-on created-at [RFC3339] timestamp."
  value       = aws_eks_addon.addon.created_at
}

output "id" {
  description = "EKS-managed add-on ID."
  value       = aws_eks_addon.addon.id
}

output "irsa" {
  description = <<-EOT
    EKS-managed add-on IRSA details.

    NOTE: These values will be null if the add-on does not require IRSA.
  EOT
  value = {
    arn         = try(module.irsa["true"].arn, null)
    description = try(module.irsa["true"].description, null)
    name        = try(module.irsa["true"].name, null)
  }
}

output "modified_at" {
  description = "EKS-managed add-on modified-at [RFC3339] timestamp."
  value       = aws_eks_addon.addon.modified_at
}

output "name" {
  description = "EKS-managed add-on name."
  value       = var.name
}
