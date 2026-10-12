variable "kubernetes_namespace" {}

variable "cluster_name" {
  description = "EKS Cluster Name"
  type        = string
  default     = "your-cluster-name"   # ? set your actual cluster name
}