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
  zone_id = aws_route53_zone.vpc.zone_id
  name    = "jenkins.demo.${var.dns_zone}"
  type    = "CNAME"
  ttl     = "300"
  records = [data.kubernetes_service.ingress_nginx.status.0.load_balancer.0.ingress.0.hostname]

  depends_on = [
    helm_release.ingress-controller,
    helm_release.jenkins,
  ]
}

resource "aws_route53_record" "spinnaker_cname" {
  zone_id = aws_route53_zone.vpc.zone_id
  name    = "spinnaker.demo.${var.dns_zone}"
  type    = "CNAME"
  ttl     = "300"
  records = [data.kubernetes_service.ingress_nginx.status.0.load_balancer.0.ingress.0.hostname]

  depends_on = [
    helm_release.ingress-controller,
    helm_release.spinnaker,
  ]
}

resource "aws_route53_record" "anchore_cname" {
  zone_id = aws_route53_zone.vpc.zone_id
  name    = "anchore.demo.${var.dns_zone}"
  type    = "CNAME"
  ttl     = "300"
  records = [data.kubernetes_service.ingress_nginx.status.0.load_balancer.0.ingress.0.hostname]

  depends_on = [
    helm_release.ingress-controller,
    helm_release.anchore,
  ]
}

resource "aws_route53_record" "grafana_cname" {
  zone_id = aws_route53_zone.vpc.zone_id
  name    = "grafana.demo.${var.dns_zone}"
  type    = "CNAME"
  ttl     = "300"
  records = [data.kubernetes_service.ingress_nginx.status.0.load_balancer.0.ingress.0.hostname]

  depends_on = [
    helm_release.ingress-controller,
  ]
}

resource "aws_route53_record" "sonarqube_cname" {
  zone_id = aws_route53_zone.vpc.zone_id
  name    = "sonarqube.demo.${var.dns_zone}"
  type    = "CNAME"
  ttl     = "300"
  records = [data.kubernetes_service.ingress_nginx.status.0.load_balancer.0.ingress.0.hostname]

  depends_on = [
    helm_release.ingress-controller,
    helm_release.sonarqube  
  ]
}

resource "aws_route53_record" "spinnaker_gate_cname" {
  zone_id = aws_route53_zone.vpc.zone_id
  name    = "spinnaker_gate.demo.${var.dns_zone}"
  type    = "CNAME"
  ttl     = "300"
  records = [data.kubernetes_service.ingress_nginx.status.0.load_balancer.0.ingress.0.hostname]

  depends_on = [
    helm_release.ingress-controller,
    helm_release.spinnaker  
  ]
}

