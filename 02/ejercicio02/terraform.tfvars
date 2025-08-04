environment = "dev"
app_name    = "app"
application_config = {
  name = "app-dev"
  features = {
    monitoring = true
    backup     = true
  }
  runtime = {
    memory = 1024
    cpu    = 4
  }
}
