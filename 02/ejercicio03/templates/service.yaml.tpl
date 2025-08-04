service_name: ${service.name}
internal_url: ${service.internal_url}

resources:
  cpu: ${service.resources.cpu}
  memory: ${service.resources.memory}

health_check:
  path: ${service.health_check.path}
  port: ${service.health_check.port}

env:
%{ for key, value in service.environment_vars ~}
  ${key}: ${value}
%{ endfor ~}

tags:
%{ for tag_key in keys(global_config.tags) ~}
  ${tag_key}: ${global_config.tags[tag_key]}
%{ endfor ~}