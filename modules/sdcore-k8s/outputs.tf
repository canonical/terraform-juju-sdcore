# Copyright 2024 Canonical Ltd.
# See LICENSE file for licensing details.

# Integration offers for external systems

output "amf_fiveg_n2_offer_url" {
  description = "AMF `fiveg_n2` offer."
  value       = juju_offer.amf-fiveg-n2.url
}

output "upf_fiveg_n3_offer_url" {
  description = "UPF `fiveg_n3` offer."
  value       = juju_offer.upf-fiveg-n3.url
}

# Outputs required to consume external offers

output "nms_app_name" {
  description = "Name of the deployed NMS application."
  value       = module.nms.app_name
}
output "fiveg_gnb_identity_endpoint" {
  description = "Name of the endpoint to integrate with fiveg_gnb_identity interface."
  value       = module.nms.fiveg_gnb_identity_endpoint
}
