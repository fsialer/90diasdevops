==================================
REPORTE DE ENTORNO: ${environment}
REGION: ${region}
==================================
**** DETALLE DE RECURSOS *****
------------------------------
| Recurso   |     Precio     |
------------------------------
%{ for recurse in list_recurses ~}
| ${recurse.name} | ${recurse.price - (recurse.price * percentage)}|
%{ endfor ~}
------------------------------

Precio total: ${price}