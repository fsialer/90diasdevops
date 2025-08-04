# REPORTE DE ENTORNO: ${environment}
## REGION: ${region}
### DETALLE DE RECURSOS
> Recursos adquiridos
%{ for recurse in list_recurses ~}
* ${recurse.name}
%{ endfor ~}