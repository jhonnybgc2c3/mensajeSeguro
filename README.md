# mensajeSeguro
Mensajería segura a través de herramientas colaborativas



Herramienta de cifrado de información estación de usuario final a estación usuario final RSA.

Control de cambios 
Versión 	Descripción 	Autor 	Fecha 	Peer Review
1.0.0	Creación 	Jhonny Alejandro Barreto Granada 	13/06/2025 	
 	 	 	 	

1.	Introducción
En la cotidianidad de nuestras labores compartimos información por correo o por herramientas colaborativas asumiendo que el cifrado de la comunicación es confiable, y sí, lo es, sin embargo estas plataformas dejan rastro en servidores donde nuestras diferentes herramientas de seguridad e implementadores de la herramienta tienen acceso, que ironía, sin embargo, velamos porque esta información solo lo tengan solo las personas que lo requieren; por este motivo se crea esta herramienta la cual busca agregar una capa de seguridad a aquellos mensajes restringidos que compartimos o nos comparten y sean confidenciales. Entre estos datos están los secretos que requieren las plataformas, que bajo intervención humana requieren ser sembradas manualmente.

3.	Caso de uso
Secretos que se deben compartir entre dos estaciones de usuario final hasta 470 caracteres (bytes) RSA o Longitudes mayores con RSA & AES.


4.	Riesgos identificados
•	Dejar copia del secreto en los diferentes activos en las que atraviesa un correo o un mensaje de un chat.

5.	Compatibilidad y requisitos

No se requiere instalación de software adicional: La herramienta utiliza las bibliotecas de criptografía integradas en Windows (System.Security.Cryptography), disponibles por defecto en PowerShell.
No se necesitan permisos de administrador: Todos los scripts están diseñados para ejecutarse en el contexto del usuario actual, sin necesidad de privilegios elevados.
No requiere licencias adicionales: Se basa exclusivamente en componentes del sistema operativo Windows, por lo que no hay costos ni licencias externas involucradas.

5.	Uso de la herramienta

PowerShell tiene una política de seguridad que puede bloquear scripts. Para evitar errores como "script no puede ejecutarse porque está deshabilitado" por lo que cada script debe ser abierto en block de notas, seleccionar todo su contenido con ctrl+e, copiarlo con ctrl+c y llevarlo a powershell, darle click derecho y darle click en pegar de todas formas a la advertencia de estar pegando varias líneas a la vez. Este procedimiento debe ser realizado en los tres scripts dependiendo del usuario que lo necesite:

El receptor del mensaje: Debe ejecutar el script “Generar par llaves RSA” y “Descifrar mensaje”. Y debe compartirle la llave publica “clave_publica” y el script “Cifrar mensaje” al remitente del mensaje.
El remitente del mensaje: Se encarga de recibir la “clave_publica” y ejecutar el script “Cifrar mensaje” .
 
Recuerda que para evitar errores con el nombre de la llave se recomienda copiar la ruta de la llave eliminando las comillas que vienen con el texto
 
 

5.1 Generación del par de claves RSA
Ejecuta el script `Generar-ClavesRSA` en PowerShell de la siguiente forma: Darle click derecho y abre el archivo con un block de notas selecciona todo el texto y pégalo en un powershell. 
No te solicitara permisos adicionales, solo te va a preguntar el nombre de la carpeta donde se almacenarán las claves (se creará dentro de tu carpeta de usuario).
El script generará un par de claves RSA de 4096 bits:
   “clave_privada” y “clave_publica”
Las claves se guardarán en la ruta que selecciones, probablemente el sistema operativo te va a esconder las extensiones por lo que si requieres validar debes darle click derecho a los archivos y buscar el .pub. Esta será la llave publica y se puede compartir con quien quieras por el medio que desees. 
Puedes copiar la ruta de acceso y le eliminas las comillas, seleccionas la ruta y la pegas en el script
Nota: probablemente el sistema operativo confunda el archivo .pub con una extensión de Publisher; No te preocupes, no va a alterar el funcionamiento de la solución.

Recomendaciones:
- ⚠️ No compartas la clave privada. Es confidencial. Sin embargo, al finalizar la transmisión del mensaje la puedes desechar.

5.2	Entrega y uso de la clave pública

Puedes compartir la clave pública con la persona que enviará el mensaje cifrado.
Comparte el script “Cifrar mensaje”, el remitente del mensaje puede usar esa herramienta para cifrar la información que te va a enviar. Es muy intuitiva y solo le va a pedir el mensaje y la llave pública. Luego de esto le entregara el criptograma el cual vas a poder descifrar con el proceso de descifrado.
Localiza el archivo “clave_publica” generado en el paso anterior.


Entrega este archivo al remitente del mensaje (por correo, o por donde desees) las llaves públicas están diseñadas para ser expuestas a cualquier entidad.
El remitente debe usar esta clave pública para cifrar el mensaje con el script “Cifrar-MensajeRSA” o como desee manejarlo. Recuerda que el script fue diseñado para PowerShell, con la librería System.Security.Cryptography Esta es la biblioteca principal del .NET Framework (y .NET Core/.NET 5+) para operaciones criptográficas. Por lo tanto, no garantizo su correcto funcionamiento con un sistema operativo diferente a Microsoft. 
RSA no está diseñado para cifrar grandes volúmenes de datos directamente, la librería trabaja con OAEP y SHA-1 como función hash (por defecto en .NET), el tamaño máximo del mensaje equivale aproximadamente a 470 caracteres (bytes). Si el mensaje excede ese tamaño, obtendrás un error como: CryptographicException: The data to be encrypted exceeds the maximum for this modulus of 512 bytes.


5.3	Recepción del mensaje cifrado y proceso de descifrado


Asegúrate de tener el archivo “clave privada” en tu posesión y recibir el archivo en base 64 el cual es el formato de facto; si el remitente utilizo el artefacto nuestro, no vas a tener que preocuparte por esto ya que en el código esta incluido el formato y la eliminación de espacios. 
Solicita al remitente que te envíe el mensaje cifrado, lo puede enviar por las herramientas colaborativas o por correo electrónico.
Usa el script de descifrado incluido aquí y usa la “clave_privada” que generamos en el primer paso “Generación del par de claves RSA” y el mensaje original será mostrado en texto plano.
Si todo sale bien te entregara el mensaje original.

Recomendaciones: Trata de trabajarlo en memoria hasta que lo siembres; cuando reinicies la maquina la memoria RAM se va a eliminar.
No lo guardes en un block de notas o en one note; no sabes cuando lo vas a comprometer o puedes almacenarlo cifrado sin embargo ten cuidado con el uso de la clave privada. Perder la privada es una forma viable de eliminar la información. Jejeje créeme, no podrás volver a recuperar el mensaje.

Parce espero te sirva mucho, un día de estos me invitas a tintico 🧯🤝


-------------------------------------/////-----------------------------------------------------



Para el cifrado de mensajes largos se debe de ejecutar de la siguiente forma:



Herramienta de cifrado de información estación de usuario final a estación usuario final RSA + AES.

Control de cambios 
Versión 	Descripción 	Autor 	Fecha 	Peer Review
1.0.0	Creación 	Jhonny Alejandro Barreto Granada 	13/06/2025 	
 	 	 	 	
Caso de uso: Secretos que se deben compartir entre dos estaciones de usuario final con más de 470 caracteres (bytes).

Uso de la herramienta

Vas a necesitar un par de claves como indica el archivo “Cifrado de mensajes RSA” y previo conocimiento en el funcionamiento de la herramienta.
La clave privada RSA en formato XML “clave_privada” y la clave pública “clave_publica”
La clave AES no se extrae directamente como texto plano, ya que por seguridad se cifra con RSA y se muestra en Base64. Aquí te explico cómo se maneja y cómo se “extrae” en el proceso de descifrado.
Recomendaciones:
- ⚠️ No compartas la clave privada. Es confidencial. Sin embargo, al finalizar la transmisión del mensaje la puedes desechar.


Entrega, uso de la clave pública y el script de cifrado

Puedes compartir la clave pública y el archivo al remitente del mensaje (por correo, o por donde desees) las llaves públicas están diseñadas para ser expuestas a cualquier entidad.
con la persona que enviará el mensaje cifrado.
Comparte el script “Cifrar MensajeHibrido”, el remitente del mensaje puede usar esa herramienta para cifrar la información que te va a enviar:
Localiza el archivo “clave_publica” generado en el paso anterior y ejecuta el script en powershell. Te entregara tres valores en base 64: 
1. Clave AES cifrada
2. IV (Initialization Vector o Vector de Inicialización)
3. El mensaje cifrado el cual vas a poder revertir con el proceso de descifrado.


Recepción del mensaje cifrado y proceso de descifrado

Asegúrate de tener el archivo “clave privada” en tu posesión y recibir el archivo en base 64 el cual es el formato de facto; si el remitente utilizo el artefacto nuestro, no vas a tener que preocuparte por esto ya que en el código esta incluido el formato y la eliminación de espacios. 
Solicita al remitente que te envíe el mensaje cifrado, la clave AES cifrada en Base64 y el vector de inicialización cuando el script lo solicita.
Usa el script de descifrado incluido “Descifrar MensajeHibrido” y usa la “clave_privada” que generamos en el primer paso “Generación del par de claves RSA” y el mensaje original será mostrado en texto plano.
Si todo sale bien te entregara el mensaje original.
Recomendaciones: Trata de trabajarlo en memoria hasta que lo siembres; cuando reinicies la maquina la memoria RAM se va a eliminar.
No lo guardes en un block de notas o en one note; no sabes cuando lo vas a comprometer o puedes almacenarlo cifrado sin embargo ten cuidado con el uso de la clave privada. Perder la privada es una forma viable de eliminar la información. Jejeje créeme, no podrás volver a recuperar el mensaje.

Parce espero te sirva mucho, un día de estos me invitas a tintico 🧯🤝


