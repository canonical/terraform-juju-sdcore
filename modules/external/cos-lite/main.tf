# Copyright 2024 Canonical Ltd.
# See LICENSE file for licensing details.

resource "juju_model" "cos" {
  name = var.model_name
}

module "alertmanager" {
  source = "git::https://github.com/canonical/alertmanager-k8s-operator//terraform"
  model    = juju_model.cos.name
  app_name = var.alertmanager_app_name
  channel  = var.alertmanager_channel
  config   = var.alertmanager_config
}

module "catalogue" {
  source   = "git::https://github.com/canonical/catalogue-k8s-operator//terraform"
  model    = juju_model.cos.name
  app_name = var.catalogue_app_name
  channel  = var.catalogue_channel
  config   = var.catalogue_config
}

module "cos-configuration" {
  count  = var.deploy_cos_configuration ? 1 : 0
  source = "../cos-configuration-k8s"

  model_name = juju_model.cos.name
  app_name   = var.cos_configuration_app_name
  channel    = var.cos_configuration_channel
  config     = var.cos_configuration_config
}

module "grafana" {
  source   = "git::https://github.com/canonical/grafana-k8s-operator//terraform"
  model    = juju_model.cos.name
  app_name = var.grafana_app_name
  channel  = var.grafana_channel
  config   = var.grafana_config
}

module "loki" {
  source = "../loki-k8s"

  model_name = juju_model.cos.name
  app_name   = var.loki_app_name
  channel    = var.loki_channel
  config     = var.loki_config
}

module "prometheus" {
  source = "../prometheus-k8s"

  model_name = juju_model.cos.name
  app_name   = var.prometheus_app_name
  channel    = var.prometheus_channel
  config     = var.prometheus_config
}

module "traefik" {
  source   = "git::https://github.com/canonical/traefik-k8s-operator//terraform"
  model    = juju_model.cos.name
  app_name = var.traefik_app_name
  channel  = var.traefik_channel
  config   = var.traefik_config
}

# Provided by Alertmanager

resource "juju_integration" "alertmanager-metrics" {
  model = var.model_name

  application {
    name     = module.alertmanager.app_name
    endpoint = module.alertmanager.endpoints.self_metrics_endpoint
  }

  application {
    name     = module.prometheus.app_name
    endpoint = module.prometheus.metrics_endpoint
  }
}
resource "juju_integration" "loki-alerting" {
  model = var.model_name

  application {
    name     = module.alertmanager.app_name
    endpoint = module.alertmanager.endpoints.alerting
  }

  application {
    name     = module.loki.app_name
    endpoint = module.loki.alertmanager_endpoint
  }
}
resource "juju_integration" "prometheus-alerting" {
  model = var.model_name

  application {
    name     = module.alertmanager.app_name
    endpoint = module.alertmanager.endpoints.alerting
  }

  application {
    name     = module.prometheus.app_name
    endpoint = module.prometheus.alertmanager_endpoint
  }
}
resource "juju_integration" "alertmanager-grafana-dashboard" {
  model = var.model_name

  application {
    name     = module.alertmanager.app_name
    endpoint = module.alertmanager.grafana_dashboard_endpoint
  }

  application {
    name     = module.grafana.app_name
    endpoint = module.grafana.endpoints.grafana_dashboard
  }
}
resource "juju_integration" "alertmanager-grafana-source" {
  model = var.model_name

  application {
    name     = module.alertmanager.app_name
    endpoint = module.alertmanager.endpoints.grafana_source
  }

  application {
    name     = module.grafana.app_name
    endpoint = module.grafana.endpoints.grafana_source
  }
}

# Provided by Catalogue

resource "juju_integration" "alertmanager-catalogue" {
  model = var.model_name

  application {
    name     = module.alertmanager.app_name
    endpoint = module.alertmanager.endpoints.catalogue
  }

  application {
    name     = module.catalogue.app_name
    endpoint = module.catalogue.endpoints.catalogue
  }
}
resource "juju_integration" "grafana-catalogue" {
  model = var.model_name

  application {
    name     = module.catalogue.app_name
    endpoint = module.catalogue.endpoints.catalogue
  }

  application {
    name     = module.grafana.app_name
    endpoint = module.grafana.endpoints.catalogue
  }
}
resource "juju_integration" "prometheus-catalogue" {
  model = var.model_name

  application {
    name     = module.catalogue.app_name
    endpoint = module.catalogue.endpoints.catalogue
  }

  application {
    name     = module.prometheus.app_name
    endpoint = module.prometheus.catalogue_endpoint
  }
}

# Provided by cos-configuration-k8s
resource "juju_integration" "cos-configuration-grafana" {
  count = var.deploy_cos_configuration ? 1 : 0
  model = var.model_name

  application {
    name     = module.cos-configuration[count.index].app_name
    endpoint = module.cos-configuration[count.index].grafana_dashboards_endpoint
  }

  application {
    name     = module.grafana.app_name
    endpoint = module.grafana.endpoints.grafana_dashboard
  }
}
resource "juju_integration" "cos-configuration-loki" {
  count = var.deploy_cos_configuration == true ? 1 : 0
  model = var.model_name

  application {
    name     = module.cos-configuration[count.index].app_name
    endpoint = module.cos-configuration[count.index].loki_config_endpoint
  }

  application {
    name     = module.loki.app_name
    endpoint = module.loki.logging_endpoint
  }
}
resource "juju_integration" "cos-configuration-prometheus" {
  count = var.deploy_cos_configuration == true ? 1 : 0
  model = var.model_name

  application {
    name     = module.cos-configuration[count.index].app_name
    endpoint = module.cos-configuration[count.index].prometheus_config_endpoint
  }

  application {
    name     = module.prometheus.app_name
    endpoint = module.prometheus.metrics_endpoint
  }
}

# Provided by Grafana

resource "juju_integration" "grafana-metrics" {
  model = var.model_name

  application {
    name     = module.grafana.app_name
    endpoint = module.grafana.endpoints.metrics_endpoint
  }

  application {
    name     = module.prometheus.app_name
    endpoint = module.prometheus.metrics_endpoint
  }
}

# Provided by Loki

resource "juju_integration" "loki-metrics" {
  model = var.model_name

  application {
    name     = module.loki.app_name
    endpoint = module.loki.metrics_endpoint
  }

  application {
    name     = module.prometheus.app_name
    endpoint = module.prometheus.metrics_endpoint
  }
}
resource "juju_integration" "loki-grafana-dashboard" {
  model = var.model_name

  application {
    name     = module.loki.app_name
    endpoint = module.loki.grafana_dashboard_endpoint
  }

  application {
    name     = module.grafana.app_name
    endpoint = module.grafana.endpoints.grafana_dashboard
  }
}
resource "juju_integration" "loki-grafana-source" {
  model = var.model_name

  application {
    name     = module.loki.app_name
    endpoint = module.loki.grafana_source_endpoint
  }

  application {
    name     = module.grafana.app_name
    endpoint = module.grafana.endpoints.grafana_source
  }
}

# Provided by Prometheus

resource "juju_integration" "prometheus-grafana-dashboard" {
  model = var.model_name

  application {
    name     = module.prometheus.app_name
    endpoint = module.prometheus.grafana_dashboard_endpoint
  }

  application {
    name     = module.grafana.app_name
    endpoint = module.grafana.grafana_dashboard_endpoint
  }
}
resource "juju_integration" "prometheus-grafana-source" {
  model = var.model_name

  application {
    name     = module.prometheus.app_name
    endpoint = module.prometheus.grafana_source_endpoint
  }

  application {
    name     = module.grafana.app_name
    endpoint = module.grafana.endpoints.grafana_source
  }
}

# Provided by Traefik

resource "juju_integration" "alertmanager-ingress" {
  model = var.model_name

  application {
    name     = module.alertmanager.app_name
    endpoint = module.alertmanager.endpoints.ingress
  }

  application {
    name     = module.traefik.app_name
    endpoint = module.traefik.endpoints.ingress
  }
}
resource "juju_integration" "catalogue-ingress" {
  model = var.model_name

  application {
    name     = module.traefik.app_name
    endpoint = module.traefik.endpoints.ingress
  }

  application {
    name     = module.catalogue.app_name
    endpoint = module.catalogue.endpoints.ingress
  }
}
resource "juju_integration" "grafana-ingress" {
  model = var.model_name

  application {
    name     = module.traefik.app_name
    endpoint = module.traefik.endpoints.traefik_route
  }

  application {
    name     = module.grafana.app_name
    endpoint = module.grafana.endpoints.ingress
  }
}
resource "juju_integration" "loki-ingress" {
  model = var.model_name

  application {
    name     = module.traefik.app_name
    endpoint = module.traefik.endpoints.ingress_per_unit
  }

  application {
    name     = module.loki.app_name
    endpoint = module.loki.ingress_endpoint
  }
}
resource "juju_integration" "prometheus-ingress" {
  model = var.model_name

  application {
    name     = module.traefik.app_name
    endpoint = module.traefik.endpoints.ingress_per_unit
  }

  application {
    name     = module.prometheus.app_name
    endpoint = module.prometheus.ingress_endpoint
  }
}
resource "juju_integration" "traefik-metrics" {
  model = var.model_name

  application {
    name     = module.traefik.app_name
    endpoint = module.traefik.endpoints.metrics_endpoint
  }

  application {
    name     = module.prometheus.app_name
    endpoint = module.prometheus.metrics_endpoint
  }
}

# Cross-model integrations

resource "juju_offer" "prometheus-remote-write" {
  model            = var.model_name
  application_name = module.prometheus.app_name
  endpoints        = [module.prometheus.receive_remote_write_endpoint]
}

resource "juju_offer" "loki-logging" {
  model            = var.model_name
  application_name = module.loki.app_name
  endpoints        = [module.loki.logging_endpoint]
}
