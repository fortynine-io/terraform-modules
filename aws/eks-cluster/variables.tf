variable "kms_key_id" {
  type        = string
  description = "(Required) KMS Key ARN or Key Alias used for encryption of CloudWatch logs, EKS Cluster secrets, etc."
  nullable    = false
}

variable "name" {
  type        = string
  description = <<-EOT
    (Required) EKS Cluster name.

    Must be between 1-100 characters in length. Must begin with an alphanumeric character, and must only contain
    alphanumeric characters, dashes and underscores (^[0-9A-Za-z][A-Za-z0-9\-_]+$).
  EOT
  nullable    = false
}

variable "vpc_config" {
  type = object({
    endpoint_private_access = optional(bool, true)
    endpoint_public_access  = optional(bool, false)
    public_access_cidrs     = optional(list(string), ["0.0.0.0/0"])
    security_group_ids      = list(string)
    subnet_ids              = list(string)
  })
  description = <<-EOT
    (Required) EKS Cluster VPC configuration details.

    Attributes:
      endpoint_private_access: Boolean indicating whether or not the EKS private API server endpoint is enabled.
        Default: true
      endpoint_public_access: Boolean indicating whether or not the EKS public API server endpoint is enabled.
        Default: false
      public_access_cidrs: List of CIDR blocks that can access the EKS public API server endpoint when enabled.
        Default: ["0.0.0.0/0"]
      subnet_ids: List of Subnet IDs (in at least two different AZs) for which EKS creates cross-account ENIs
        to permit communication between worker nodes and the Kubernetes control plane.
  EOT
}

# TODO: delete this (and look it up based on SG), or move it to [vpc_config]...
variable "vpc_id" {
  type        = string
  description = "(Required) ID of the VPC to associate with the EKS Cluster."
  nullable    = false
}


variable "auto_mode" {
  type        = bool
  description = <<-EOT
    (Optional) Boolean indicating whether or not to enable EKS Auto Mode for automating various cluster maintenance
    tasks such as EC2 instance auto-scaling and Node upgrades, EBS persistent volumes, Kubernetes networking, etc.
  EOT
  default     = false
  nullable    = false
}

variable "cluster_access" {
  type = object({
    cluster_admin = optional(list(string))
    admin         = optional(list(string))
    edit          = optional(list(string))
    view          = optional(list(string))
  })
  description = <<-EOT
    (Optional) Cluster-level EKS access authorization for AWS principals.

    Attributes:
      - cluster_admin: (Optional) List of AWS Principal ARNs to grant cluster administrator access.
      - admin: (Optional) List of AWS Principal ARNs to grant administrator access (all namespaces).
      - edit: (Optional) List of AWS Principal ARNs to grant edit access (all namespaces).
      - view: (Optional) List of AWS Principal ARNs to grant view access (all namespaces).

    Notes:
      - Only list AWS Principals once throughout the configuration. There is no need or benefit to granting multiple
        access levels to a single principal as all higher access levels contain any and all privileges defined at lower
        levels.

    See: https://aws.amazon.com/blogs/containers/a-deep-dive-into-simplified-amazon-eks-access-management-controls
  EOT
  default = {
    cluster_admin = []
    admin         = []
    edit          = []
    view          = []
  }
  nullable = false
}

variable "cluster_version" {
  type        = string
  description = <<-EOT
    (Optional) Desired Kubernetes control plane version. The value must be configured and increased to upgrade the
    version when desired. Downgrades are not supported by EKS.
  EOT
  default     = "1.34"
  nullable    = false

  validation {
    condition     = tonumber(var.cluster_version) >= 1.34
    error_message = "[cluster_version] must be greater than or equal to 1.34."
  }
}

variable "fargate" {
  type        = bool
  description = <<-EOT
    Boolean indicating whether or not to enable Fargate Profiles for the EKS Cluster.

    Notes:
      - If enabled, a "default" Fargate Profile is provisioned automatically for you with selectors configured for the
        "default" and "kube-system" namespaces.
  EOT
  default     = false
  nullable    = false
}

variable "fargate_profiles" {
  type = map(object({
    namespace = string
    labels    = optional(map(string), {})
  }))
  description = <<-EOT
    (Optional) Custom Fargate Profile configuration map for the EKS Cluster. Each top-level map key is used as the
    Fargate Profile name.

    Notes:
      - This setting is ignored unless [fargate] is set to true.

    Attributes:
      - namespace: (Required) Kubernetes Namespace to associate with the Fargate Profile.
      - labels: (Optional) Map of Kubernetes labels to apply for Fargate Profile Pod affinity.
  EOT
  default     = {}
  nullable    = false
}

variable "log_retention_in_days" {
  type        = number
  description = <<-EOT
    (Optional) Specifies the number of days to retain log events in the associated CloudWatch Log Group.

    Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653, and 0.
    If you select 0, the events in the log group are always retained and never expire.
  EOT
  default     = 14
  nullable    = false
}

variable "log_types" {
  type        = list(string)
  description = <<-EOT
    (Optional) List of Kubernetes control plane logging types to enable.

    See: https://docs.aws.amazon.com/eks/latest/userguide/control-plane-logs.html
  EOT
  default     = ["audit", "api", "authenticator", "controllerManager", "scheduler"]
  nullable    = false
}

variable "role_policies" {
  type        = list(string)
  description = <<-EOT
    (Optional) List of IAM Policy ARNs to attach to the EKS Cluster's IAM Role.

    NOTE: The following IAM Policies are attached to the EKS Cluster Role by default:
      - arn:aws:iam::aws:policy/AmazonEKSClusterPolicy
      - arn:aws:iam::aws:policy/AmazonEKSVPCResourceController
    NOTE: If auto-mode is enabled, these additional IAM Policies are attached by default:
      - arn:aws:iam::aws:policy/AmazonEKSComputePolicy
      - arn:aws:iam::aws:policy/AmazonEKSBlockStoragePolicy
      - arn:aws:iam::aws:policy/AmazonEKSLoadBalancingPolicy
      - arn:aws:iam::aws:policy/AmazonEKSNetworkingPolicy
  EOT
  default     = []
  nullable    = false
}

variable "tags" {
  type        = map(string)
  description = <<-EOT
    (Optional) Key-value map of resource tags to be applied to all taggable resources within this module.

    If also configured with 'provider.default_tags' in the root module, tags with matching keys here will override
    those defined at the provider-level.
  EOT
  default     = {}
  nullable    = false
}

variable "timeouts" {
  type = object({
    create = string
    update = string
    delete = string
  })
  description = <<-EOT
    (Optional) EKS Cluster timeout configuration determining how long to wait for create, delete, and update processes.
  EOT
  default = {
    create = "30m"
    delete = "15m"
    update = "60m"
  }
  nullable = false
}

variable "upgrade_support_type" {
  type        = string
  description = <<-EOT
    (Optional) EKS Cluster upgrade policy support type.

    NOTE: Valid values are:
      - "EXTENDED" - The cluster will enter extended support after the standard support period ends and will incur
        additional extended support charges.
      - "STANDARD" - (default) The cluster will be automatically upgraded after the standard support window for
        [cluster_version] has expired.
  EOT
  default     = "STANDARD"
  nullable    = false
}
