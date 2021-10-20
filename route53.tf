data "kubernetes_service" "ingress_nginx" {
  metadata {
    name      = "ingress-nginx-controller"
    namespace = "ingress-nginx"
  }

  depends_on = [
    helm_release.ingress-controller,
  ]
}

resource "aws_route53_record" "jenkins_cname" {
  zone_id = data.aws_route53_zone.vpc.zone_id
  name    = "jenkins.${var.dns_zone}"
  type    = "CNAME"
  ttl     = "300"
  records = [data.kubernetes_service.ingress_nginx.status.0.load_balancer.0.ingress.0.hostname]

  depends_on = [
    helm_release.ingress-controller,
    helm_release.jenkins,
  ]
}

resource "aws_route53_record" "portainer_cname" {
  zone_id = data.aws_route53_zone.vpc.zone_id
  name    = "portainer.${var.dns_zone}"
  type    = "CNAME"
  ttl     = "300"
  records = [data.kubernetes_service.ingress_nginx.status.0.load_balancer.0.ingress.0.hostname]

  depends_on = [
    helm_release.ingress-controller,
    helm_release.portainer,
  ]
}

resource "aws_route53_record" "spinnaker_cname" {
  zone_id = data.aws_route53_zone.vpc.zone_id
  name    = "spinnaker.${var.dns_zone}"
  type    = "CNAME"
  ttl     = "300"
  records = [data.kubernetes_service.ingress_nginx.status.0.load_balancer.0.ingress.0.hostname]

  depends_on = [
    helm_release.ingress-controller,
    helm_release.spinnaker,
  ]
}

resource "aws_route53_record" "anchore_cname" {
  zone_id = data.aws_route53_zone.vpc.zone_id
  name    = "anchore.${var.dns_zone}"
  type    = "CNAME"
  ttl     = "300"
  records = [data.kubernetes_service.ingress_nginx.status.0.load_balancer.0.ingress.0.hostname]

  depends_on = [
    helm_release.ingress-controller,
    helm_release.anchore,
  ]
}

resource "aws_route53_record" "grafana_cname" {
  zone_id = data.aws_route53_zone.vpc.zone_id
  name    = "grafana.${var.dns_zone}"
  type    = "CNAME"
  ttl     = "300"
  records = [data.kubernetes_service.ingress_nginx.status.0.load_balancer.0.ingress.0.hostname]

  depends_on = [
    helm_release.ingress-controller,
  ]
}

resource "aws_route53_record" "sonarqube_cname" {
  zone_id = data.aws_route53_zone.vpc.zone_id
  name    = "sonarqube.${var.dns_zone}"
  type    = "CNAME"
  ttl     = "300"
  records = [data.kubernetes_service.ingress_nginx.status.0.load_balancer.0.ingress.0.hostname]

  depends_on = [
    helm_release.ingress-controller,
    helm_release.sonarqube
  ]
}

resource "aws_route53_record" "spinnaker_gate_cname" {
  zone_id = data.aws_route53_zone.vpc.zone_id
  name    = "spinnaker_gate.${var.dns_zone}"
  type    = "CNAME"
  ttl     = "300"
  records = [data.kubernetes_service.ingress_nginx.status.0.load_balancer.0.ingress.0.hostname]

  depends_on = [
    helm_release.ingress-controller,
    helm_release.spinnaker
  ]
}

resource "aws_route53_record" "selenium_gate_cname" {
  zone_id = data.aws_route53_zone.vpc.zone_id
  name    = "selenium.${var.dns_zone}"
  type    = "CNAME"
  ttl     = "300"
  records = [data.kubernetes_service.ingress_nginx.status.0.load_balancer.0.ingress.0.hostname]

  depends_on = [
    helm_release.ingress-controller,
    helm_release.selenium3_grid
  ]
}

