locals {
  percentage = var.region == "us-east-1"?0.5 : ( var.region == "us-east-2" ? 0.4 : 0.3)
  price = var.list_recurses != null ? sum([for item in var.list_recurses : item.price - (item.price*local.percentage)]) : 0
}

resource "local_file" "report_coste" {
  filename = "outputs/cost-${var.environment}-report.txt"
  content = templatefile("${path.module}/templates/report_coste.tpl", {
    environment  = var.environment
    price      = local.price
    list_recurses = var.list_recurses
    region = var.region
    percentage = local.percentage
  })
}

resource "local_file" "report_config" {
  filename = "outputs/conf-${var.environment}-report.md"
  content = templatefile("${path.module}/templates/conf_report.tpl", {
    environment  = var.environment
    price      = local.price
    list_recurses = var.list_recurses
    region = var.region
  })
}