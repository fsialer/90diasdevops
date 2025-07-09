⚙️ Instrucciones
1. Instalación de dependencias
Asegurate de tener instalados:
```
vagrant --version
ansible --version
virtualbox --version
```

Si te falta alguno, podés instalarlo vía Homebrew (macOS) o apt (Linux).

2. Ejecutar la VM
```
vagrant up
```

Esto levantará la VM y ejecutará automáticamente el playbook playbook.yml.

3. Verificar
Una vez finalizado:
```
vagrant ssh
curl localhost
```

Deberías ver tu landing page servida por Nginx desde la máquina virtual.

🧠 Tips
* Podés personalizar la landing en roles/nginx/files/index.html
* Para hacer debugging, usá:

```
ansible-playbook playbook.yml -vvv
```

Para volver a ejecutar el provisionamiento sin destruir la VM:

```
vagrant provision
```