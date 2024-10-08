# Copyright 2024 Canonical Ltd.
# See LICENSE file for licensing details.

variable "model" {
  description = "Reference to the Juju model to deploy application to."
  type        = string
}

variable "sdcore_channel" {
  description = "The channel to use when deploying Charmed Aether SD-Core charms."
  type        = string
  default     = "1.5/edge"
}

variable "amf_config" {
  description = "Application config for the AMF. Details about available options can be found at https://charmhub.io/sdcore-amf-k8s-operator/configure."
  type        = map(string)
  default     = {}
}

variable "nssf_config" {
  description = "Application config for the NSSF. Details about available options can be found at https://charmhub.io/sdcore-nssf-k8s-operator/configure."
  type        = map(string)
  default     = {}
}

variable "upf_config" {
  description = "Application config for the AMF. Details about available options can be found at https://charmhub.io/sdcore-upf-k8s-operator/configure."
  type        = map(string)
  default     = {}
}

# Grafana Agent K8s

variable "grafana_agent_channel" {
  description = "The channel to use when deploying `grafana-agent-k8s` charm."
  type        = string
  default     = "latest/stable"
}
variable "grafana_agent_config" {
  description = "Additional configuration for the Grafana Agent. Details about available options can be found at https://charmhub.io/grafana-agent-k8s/configure."
  type        = map(string)
  default     = {}
}

# MongoDB K8s

variable "mongo_channel" {
  description = "The channel to use when deploying `mongodb-k8s` charm."
  type        = string
  default     = "6/beta"
}
variable "mongo_config" {
  description = "Additional configuration for the MongoDB. Details about available options can be found at https://charmhub.io/mongodb-k8s/configure?channel=6/beta."
  type        = map(string)
  default     = {}
}

# Self-signed certificates

variable "self_signed_certificates_channel" {
  description = "The channel to use when deploying `self-signed-certificates-operator` charm."
  type        = string
  default     = "latest/stable"
}
variable "self_signed_certificates_config" {
  description = "Additional configuration for the Self-Signed-Certificates. Details about available options can be found at https://charmhub.io/self-signed-certificates-operator/configure."
  type        = map(string)
  default     = {}
}

# Traefik K8s

variable "traefik_channel" {
  description = "The channel to use when deploying `traefik-k8s` charm."
  type        = string
  default     = "latest/stable"
}
variable "traefik_config" {
  description = "Additional configuration for the Traefik. Details about available options can be found at https://charmhub.io/traefik-k8s-operator/configure."
  type        = map(string)
  default = {
    routing_mode = "subdomain"
  }
}
