# Copyright 2024 Canonical Ltd.
# See LICENSE file for licensing details.

# Integration offers for external systems

output "amf_fiveg_n2_offer_url" {
  description = ""
  value       = juju_offer.amf-fiveg-n2.url
}

output "nms_fiveg_core_gnb_offer_url" {
  description = "NMS `fiveg_core_gnb` offer."
  value       = juju_offer.nms-fiveg-core-gnb.url
}

# Outputs required to consume external offers

output "nms_app_name" {
  description = "Name of the deployed NMS application."
  value       = module.nms.app_name
}
output "fiveg_n4_endpoint" {
  description = "Name of the endpoint to integrate with fiveg_n4 interface."
  value       = module.nms.requires.fiveg_n4
}

output "grafana_agent_app_name" {
  description = "Name of the deployed Grafana Agent application."
  value       = module.grafana-agent.app_name
}
output "send_remote_write_endpoint" {
  description = "Name of the endpoint to forward client charms metrics and associated alert rules to Prometheus using prometheus_remote_write interface."
  value       = module.grafana-agent.endpoints.send_remote_write
}
output "logging_consumer_endpoint" {
  description = "Name of the endpoint to send the logs to Loki using loki_push_api interface."
  value       = module.grafana-agent.endpoints.logging_consumer
}
