# Copyright 2024 Canonical Ltd.
# See LICENSE file for licensing details.

output "amf_fiveg_n2_offer_url" {
  description = ""
  value       = juju_offer.amf-fiveg-n2.url
}

output "nms_app_name" {
  description = "Name of the deployed NMS application."
  value       = module.nms.app_name
}

output "fiveg_gnb_identity_endpoint" {
  description = "Name of the endpoint to integrate with fiveg_gnb_identity interface."
  value       = module.nms.fiveg_gnb_identity_endpoint
}

output "upf_app_name" {
  description = "Name of the deployed UPF application."
  value       = module.upf.app_name
}

output "fiveg_n3_endpoint" {
  description = "Name of the endpoint used to provide information on connectivity to the N3 plane."
  value       = module.upf.fiveg_n3_endpoint
}
