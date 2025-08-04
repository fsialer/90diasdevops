microservices = {
  "user_service" = {
    port         = 8081
    language     = "java"
    memory_mb    = 1024
    replicas     = 2
    dependencies = [""]
  },
  "customer_service" = {
    port         = 8082
    language     = "java"
    memory_mb    = 1024
    replicas     = 2
    dependencies = ["user_service"]
  },
  "employee_service"={
    port         = 8083
    language     = "java"
    memory_mb    = 1024
    replicas     = 2
    dependencies = ["user_service"]
  },
  "logistic_service" = {
    port         = 8084
    language     = "python"
    memory_mb    = 1024
    replicas     = 2
    dependencies = ["employee_service"]
  }
}
