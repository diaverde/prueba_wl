# prueba_wl

Este proyecto permite interactuar con la API de Spotify y acceder a información
de categorías, artistas, álbumes, pistas y listas de reproducción de dicha aplicación.

## Detalles de la aplicación
La aplicación permite: 
- Realizar un _login_ sencillo a través de correo electrónico y contraseña o
usar credenciales de Facebook o Google.
- Conectarse a la API de Spotify utilizando las credenciales adecuadas
- Alternar información entre 2 países (Colombia y Australia) para obtener:
    * Lista de categorías por país
    * Lista de las playlists dentro de una categoría
    * Lista de las canciones dentro una playlist
    * Detalles de un Artista
    * Lista de los albumes de un Artista
    * Lista de las canciones top de un artista
    * Lista de los últimos lanzamientos por país
- Realizar una búsqueda dentro de Spotify.<br>

En cualquier momento el usuario puede visualizar sus datos en el ícono de 
la parte superior derecha de la pantalla.

## Capturas de pantalla
<span><img src="http://www.haztudron.com/wl/screenshot_1.png" alt="1">
<img src="http://www.haztudron.com/wl/screenshot_2.png" alt="2">
<img src="http://www.haztudron.com/wl/screenshot_3.png" alt="3">
<img src="http://www.haztudron.com/wl/screenshot_4.png" alt="4">
<img src="http://www.haztudron.com/wl/screenshot_5.png" alt="5">
<img src="http://www.haztudron.com/wl/screenshot_6.png" alt="6">
<img src="http://www.haztudron.com/wl/screenshot_7.png" alt="7">
<img src="http://www.haztudron.com/wl/screenshot_8.png" alt="8">
<img src="http://www.haztudron.com/wl/screenshot_9.png" alt="9">
<img src="http://www.haztudron.com/wl/screenshot_10.png" alt="10">
<img src="http://www.haztudron.com/wl/screenshot_11.png" alt="11">
<img src="http://www.haztudron.com/wl/screenshot_12.png" alt="12">
</span>

## Descripción técnica
Después de analizar los requerimientos de la aplicación se hizo una distribución jerárquica de las
pantallas requeridas para establecer el flujo de navegación. El inicio de aplicación y las
rutas creadas se establecen en "main.dart". Los modelos requeridos para la información extraida
de Spotify se encuentran en una carpeta dedicada ("models"). Se utiliza el apoyo de
la librería _Provider_ para facilidar el manejo del estado entre pantallas.

## Nota importante
El usuario debe proveer sus propias credenciales de Spotify para acceder a la
aplicación. Estas deben incluirse en un archivo llamado "spotify_data.json" a
almacenar en un carpeta llamada "config". El archivo debe tener esta estructura:<br>
{
  "clientID": "\<_ID de cliente suministrado por Spotify_\>",
  "clientSecret": "\<_Secreto de cliente suministrado por Spotify_\>"
}

## Extras
Se despliega también en modo Web, accesible en este enlace:<br>
https://agreeable-sea-0ef279b10.1.azurestaticapps.net/#/

## Datos de contacto
Desarrollador: Andrés Sánchez<br>
Localizado en: Bogotá, Colombia<br>
Correo electrónico: diaverde77@gmail.com<br>
Perfil de LinkedIn: https://www.linkedin.com/in/andr%C3%A9s-s%C3%A1nchez-a28aa8199/

## Por qué escoger Flutter
Se ha escogido Flutter para este proyecto porque:
- Proporciona un alto rendimiento y fidelidad para crear aplicaciones multiplataforma (Android, IOS e incluso Web) teniendo como base un mismo código compartido.
- Gracias a esto el tiempo de desarrollo es menor y se pueden hacer cliclos de creación y mejora más rápidos y efectivos.
- Tiene el soporte de una gran compañía como Google, con amplia documentación y constantes mejoras.
- Es divertido.