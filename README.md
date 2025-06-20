# Health-app

#DESCRIPCIÓN
La interfaz de HealthApp fue diseñada en Figma para posteriormente ser programada dentro de Flutter en donde se pretendió emular
el diseño desde Figma. Se genera una ventana mediante AndroidStudio la cual muestra la bienvenida, luego se reciben los datos del usuario como nombre, edad, género y ocupación; posterior a ello se genera un boton de comienzo de visualización de la señal ECG ya que su 
adquisición permite detectar diversas patologías cardíacas y su implementación como Point of Care. La ventana final 
muestra la variable fisiológica en tiempo real y una recomendación personalizada al usuario. 

Enlace a mockup: https://www.canva.com/design/DAGpcouywkk/EAB4MJxEwfqnh6Vv0_cscQ/edit?utm_content=DAGpcouywkk&utm_campaign=designshare&utm_medium=link2&utm_source=sharebutton

#1 Validación de formularios
Ahora los campos del formulario de registro (nombre, edad, género y ocupación) deben ser llenados correctamente antes de poder continuar. Esto evita registros incompletos o vacíos.

#2 Separación de constantes mágicas
En lugar de usar valores “quemados” en el código (como colores, velocidades o límites), los definí como constantes (ecgMaxY, refreshRate, primaryColor). Esto mejora la legibilidad del código y facilita futuros cambios.

#3 Mejora en la visualización de la señal ECG
Mejoré la experiencia visual de la gráfica que muestra la señal del electrocardiograma. En lugar de una línea rígida, ahora la señal se traza con una curva suave que se ve mucho más natural y realista. Además, la animación avanza en tiempo real y se detiene automáticamente cuando finalizan los datos, simulando de forma más fiel una toma fisiológica.

#4 Limpieza y uso eficiente de dependencias
Simplifiqué el proyecto eliminando dependencias no esenciales, usando solo lo necesario para mantener la app ligera y clara.

#5 Separación de lógica y presentación
La lógica como la carga del archivo .csv y el manejo de animaciones se separó del diseño visual. Esto hace que el proyecto sea más ordenado, fácil de leer y escalar en el futuro.
Cambios realizados por Javier Reyes

Enlace a video de app en funcionamiento: https://www.canva.com/design/DAGpzH_xktg/xItwtGAes0ofSWt2fqFP9Q/edit?utm_content=DAGpzH_xktg&utm_campaign=designshare&utm_medium=link2&utm_source=sharebutton