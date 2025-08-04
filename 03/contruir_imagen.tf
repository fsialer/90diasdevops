# Build desde Dockerfile
resource "docker_image" "custom_app" {
  name = "roxs-app:latest"
  
  build {
    context    = path.module  # Directorio con Dockerfile
    dockerfile = "Dockerfile"
    
    # Args de build
    build_args = {
      APP_VERSION = "1.0.0"
      ENV         = "production"
    }
    
    # Tags adicionales
    tag = [
      "roxs-app:1.0.0",
      "roxs-app:latest"
    ]
  }
  
  # Triggers para rebuild
  triggers = {
    dockerfile_hash = filemd5("${path.module}/Dockerfile")
    src_hash       = sha256(join("", [
      for f in fileset(path.module, "src/**") : filemd5("${path.module}/${f}")
    ]))
  }
}