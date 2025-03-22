output "load_balancer_dns_name" {
  description = "The DNS name of the load balancer"
  value       = module.loadbalancer.alb_dns_name
}
