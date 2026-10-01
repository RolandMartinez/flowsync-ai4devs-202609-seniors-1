## Purpose

Permitir que una persona cree una cuenta, inicie sesión, mantenga una sesión activa entre
recargas y la cierre, con acceso a sus propios datos de perfil y nada más.

## Requirements

### Requirement: Crear una cuenta nueva
El sistema SHALL permitir crear una cuenta con email, contraseña y confirmación de
contraseña; el nombre completo es opcional.

#### Scenario: Alta con nombre completo
- **WHEN** se envía un alta con un email no registrado, contraseña y confirmación
  coincidentes, y un nombre completo
- **THEN** la respuesta es 200, la cuenta se crea con ese nombre, y el cuerpo incluye los
  datos del usuario y un token de acceso

#### Scenario: Alta con el nombre enviado como nulo
- **WHEN** se envía un alta con un email no registrado, contraseña y confirmación
  coincidentes, y el campo del nombre completo enviado explícitamente vacío (nulo)
- **THEN** la respuesta es 200, la cuenta se crea con el nombre vacío, y el cuerpo incluye
  los datos del usuario y un token de acceso

### Requirement: Exigir que la clave del nombre esté presente, aunque sea vacía
El sistema SHALL rechazar un alta en la que la clave del nombre completo no se envía en
absoluto, aunque el nombre en sí no sea obligatorio.

#### Scenario: Clave del nombre ausente
- **WHEN** se envía un alta sin incluir la clave del nombre completo en la petición
- **THEN** la respuesta es 422 y señala el campo del nombre como requerido

### Requirement: Rechazar un email ya registrado
El sistema SHALL rechazar un alta cuyo email ya pertenezca a una cuenta existente, y
mostrar en pantalla un mensaje que invite a iniciar sesión en su lugar.

#### Scenario: Email duplicado
- **WHEN** se envía un alta con un email que ya tiene cuenta
- **THEN** la respuesta es 422 y señala el campo del email como la causa

#### Scenario: Aviso en la pantalla de registro
- **WHEN** se intenta crear una cuenta desde la pantalla de registro con un email que ya
  tiene cuenta
- **THEN** bajo el campo de email aparece el aviso "Ese email ya está registrado. Inicia
  sesión en su lugar."

### Requirement: Tratar como cuentas distintas los emails que solo difieren en mayúsculas
El sistema SHALL permitir dar de alta un email que ya existe con otra combinación de
mayúsculas y minúsculas, sin tratarlo como duplicado.

#### Scenario: Mismo email con mayúsculas distintas
- **WHEN** ya existe una cuenta con un email en minúsculas y se envía un alta con el mismo
  email pero con alguna letra en mayúscula
- **THEN** la respuesta es 200 y se crea una segunda cuenta

### Requirement: Exigir confirmación de contraseña
El sistema SHALL rechazar un alta cuando la contraseña y su confirmación no coinciden.

#### Scenario: Confirmación distinta
- **WHEN** la confirmación de contraseña no coincide con la contraseña
- **THEN** la respuesta es 422 y señala el campo de confirmación como la causa

### Requirement: Rechazar un email con formato inválido
El sistema SHALL rechazar un alta cuando el email no tiene forma de email.

#### Scenario: Email mal formado
- **WHEN** se envía un alta con un texto que no tiene forma de email
- **THEN** la respuesta es 422 y señala el campo del email como la causa

### Requirement: Exigir una longitud de contraseña entre 8 y 32 caracteres
El sistema SHALL rechazar un alta cuando la contraseña tiene menos de 8 o más de 32
caracteres.

#### Scenario: Contraseña demasiado corta
- **WHEN** se envía un alta con una contraseña de menos de 8 caracteres (y su confirmación
  igual de corta)
- **THEN** la respuesta es 422 y señala tanto el campo de la contraseña como el de su
  confirmación

#### Scenario: Contraseña demasiado larga
- **WHEN** se envía un alta con una contraseña de más de 32 caracteres (y su confirmación
  igual de larga)
- **THEN** la respuesta es 422 y señala tanto el campo de la contraseña como el de su
  confirmación

### Requirement: Iniciar sesión con credenciales correctas
El sistema SHALL autenticar a una persona que envía un email y una contraseña que
coinciden con una cuenta existente, y emitirle un token de acceso nuevo.

#### Scenario: Credenciales correctas
- **WHEN** se envía un email y contraseña que coinciden con una cuenta existente
- **THEN** la respuesta es 200 e incluye los datos del usuario y un token de acceso nuevo

### Requirement: Exigir email y contraseña para iniciar sesión
El sistema SHALL rechazar un intento de inicio de sesión al que le falte el email o la
contraseña, señalando cada campo que falte.

#### Scenario: Campos vacíos en la pantalla de login
- **WHEN** se intenta iniciar sesión desde la pantalla de login sin escribir nada
- **THEN** bajo el campo de email aparece "Falta rellenar el email." y bajo el de
  contraseña aparece "Falta rellenar la contraseña."

### Requirement: Rechazar credenciales incorrectas sin distinguir la causa
El sistema SHALL rechazar un intento de inicio de sesión con el mismo código y el mismo
mensaje genérico, tanto si el email no existe como si la contraseña es incorrecta.

#### Scenario: Contraseña incorrecta
- **WHEN** se envía un email de una cuenta existente con una contraseña que no coincide
- **THEN** la respuesta es 400, con un mensaje de credenciales inválidas y sin más detalle

#### Scenario: Email inexistente
- **WHEN** se envía un email que no pertenece a ninguna cuenta
- **THEN** la respuesta es 400, con el mismo código y el mismo mensaje de credenciales
  inválidas que una contraseña incorrecta

### Requirement: Exigir sesión para ver el perfil
El sistema SHALL exigir un token de acceso válido para devolver los datos de perfil de una
persona.

#### Scenario: Sin token
- **WHEN** se piden los datos de perfil sin un token de acceso
- **THEN** la respuesta es 401

#### Scenario: Con token válido
- **WHEN** se piden los datos de perfil con un token de acceso vigente
- **THEN** la respuesta es 200 e incluye los datos de esa cuenta

### Requirement: Mostrar "Sin nombre" en el perfil cuando la cuenta no tiene nombre
El sistema SHALL mostrar el texto "Sin nombre" en la pantalla de perfil cuando la cuenta no
tiene nombre completo.

#### Scenario: Perfil de una cuenta sin nombre
- **WHEN** se visita la pantalla de perfil de una cuenta sin nombre completo
- **THEN** donde iría el nombre se lee "Sin nombre"

### Requirement: Mostrar iniciales derivadas de las dos primeras palabras de un nombre
El sistema SHALL calcular unas iniciales de dos letras a partir de las dos primeras
palabras del nombre completo de la cuenta, cuando ese nombre tiene dos o más palabras.

#### Scenario: Nombre de tres o más palabras
- **WHEN** la cuenta tiene un nombre completo de tres o más palabras
- **THEN** las iniciales son la primera letra de la primera palabra y la primera letra de
  la segunda, en mayúsculas — no de la última

### Requirement: Mostrar iniciales cuando el nombre es una sola palabra
El sistema SHALL calcular igualmente unas iniciales de dos letras cuando el nombre completo
de la cuenta es una sola palabra.

#### Scenario: Nombre de una sola palabra
- **WHEN** la cuenta tiene un nombre completo de una sola palabra
- **THEN** las iniciales son las dos primeras letras de esa palabra, en mayúsculas

### Requirement: Mostrar iniciales cuando no hay nombre
El sistema SHALL calcular unas iniciales igualmente cuando la cuenta no tiene nombre
completo.

#### Scenario: Sin nombre completo
- **WHEN** la cuenta no tiene nombre completo
- **THEN** el sistema devuelve igualmente unas iniciales de dos letras, derivadas del email

### Requirement: Cerrar sesión invalida el token
El sistema SHALL invalidar el token de acceso usado al cerrar sesión, de forma que deje de
servir para peticiones posteriores.

#### Scenario: Reutilizar el token tras cerrar sesión
- **WHEN** se cierra sesión con un token (la respuesta de cerrar sesión es 200) y después se
  vuelve a usar ese mismo token para pedir el perfil
- **THEN** la respuesta al pedir el perfil es 401

### Requirement: Cerrar sesión no afecta a otras sesiones activas
El sistema SHALL invalidar únicamente el token con el que se cierra sesión, dejando
intactos los demás tokens activos de la misma cuenta.

#### Scenario: Dos sesiones activas, se cierra una
- **WHEN** una cuenta tiene dos tokens de acceso activos (por ejemplo, dos inicios de
  sesión) y se cierra sesión con uno de ellos
- **THEN** pedir el perfil con ese token responde 401, pero con el otro token sigue
  respondiendo 200 con normalidad

### Requirement: Responder siempre en JSON
El sistema SHALL responder en formato JSON a toda petición de esta vertical, incluso si
quien la hace no lo pide explícitamente.

#### Scenario: Petición sin cabecera de formato
- **WHEN** se hace una petición a cualquier ruta de esta vertical sin indicar que se acepta
  JSON
- **THEN** la respuesta llega igualmente en JSON

### Requirement: Impedir el acceso a pantallas protegidas sin sesión
El sistema SHALL redirigir a la pantalla de inicio de sesión a quien intente ver una
pantalla protegida sin una sesión activa.

#### Scenario: Visitar el perfil sin sesión
- **WHEN** una persona sin sesión activa visita la pantalla de perfil
- **THEN** se la redirige a la pantalla de inicio de sesión

### Requirement: Impedir ver login o registro con sesión activa
El sistema SHALL redirigir a la pantalla de perfil a quien ya tiene una sesión activa e
intenta ver las pantallas de inicio de sesión o registro.

#### Scenario: Visitar login con sesión activa
- **WHEN** una persona con sesión activa visita la pantalla de inicio de sesión
- **THEN** se la redirige a la pantalla de perfil

#### Scenario: Visitar registro con sesión activa
- **WHEN** una persona con sesión activa visita la pantalla de registro
- **THEN** se la redirige a la pantalla de perfil

### Requirement: Redirigir una ruta desconocida según el estado de sesión
El sistema SHALL tratar cualquier dirección que no sea una de las pantallas conocidas como
si fuera la pantalla de perfil, dejando que el resto de reglas de sesión decidan qué se ve
realmente.

#### Scenario: Ruta desconocida sin sesión
- **WHEN** una persona sin sesión activa visita una dirección que no corresponde a ninguna
  pantalla conocida
- **THEN** termina en la pantalla de inicio de sesión

#### Scenario: Ruta desconocida con sesión activa
- **WHEN** una persona con sesión activa visita una dirección que no corresponde a ninguna
  pantalla conocida
- **THEN** termina en la pantalla de perfil

### Requirement: Cerrar la sesión local si el token guardado es rechazado
El sistema SHALL borrar la sesión guardada y mostrar un aviso de caducidad, cuando el
servidor rechaza explícitamente el token guardado.

#### Scenario: Token guardado inválido al arrancar
- **WHEN** se abre la aplicación con un token guardado y pedir el perfil con él responde 401
- **THEN** la sesión guardada se borra, se muestra la pantalla de inicio de sesión, y en
  ella aparece el aviso "Tu sesión ha caducado. Vuelve a iniciar sesión."

### Requirement: Conservar el token guardado ante un fallo que no es un rechazo
El sistema SHALL conservar el token guardado en el dispositivo, sin borrarlo, cuando la
validación de un token guardado falla por un motivo distinto a un rechazo explícito del
servidor (por ejemplo, el servidor no responde).

#### Scenario: El servidor no responde al validar un token guardado
- **WHEN** se abre la aplicación con un token guardado y el servidor no responde a la
  petición que lo valida
- **THEN** se muestra la pantalla de inicio de sesión con el aviso "No se pudo conectar con
  el servidor. Comprueba que el backend está arrancado.", y el token guardado no se borra

#### Scenario: El servidor vuelve a responder y se recarga
- **WHEN**, después de lo anterior, el servidor vuelve a estar disponible y se recarga la
  aplicación
- **THEN** la sesión se recupera automáticamente con el mismo token, sin pedir credenciales
  de nuevo

### Requirement: Mostrar una pantalla de carga mientras se resuelve un token guardado
El sistema SHALL mostrar una pantalla de carga, y no la de inicio de sesión ni una pantalla
protegida, mientras todavía no se sabe si un token guardado es válido.

#### Scenario: Validación de token en curso
- **WHEN** se abre la aplicación con un token guardado y la respuesta sobre su validez
  todavía no ha llegado
- **THEN** se muestra una pantalla de carga, no el contenido protegido ni la de inicio de
  sesión

### Requirement: Cerrar sesión localmente aunque el servidor no responda
El sistema SHALL dar por cerrada la sesión en el dispositivo aunque la petición de cierre
de sesión al servidor falle.

#### Scenario: Cerrar sesión sin confirmación del servidor
- **WHEN** se pide cerrar sesión y la petición al servidor no se completa con éxito
- **THEN** la sesión se cierra en el dispositivo de todas formas y se muestra la pantalla de
  inicio de sesión

---

## Parte B — las tres listas

### 1. Los dos números

Requisitos escritos: **25**
Requisitos comprobados (abriendo el código y probando contra el sistema corriendo, no solo
leyendo): **22**

Los 3 escritos y no comprobados en marcha:
- Visitar la pantalla de registro con sesión activa (comparte el mismo guardia de código
  que la de login, que sí comprobé, pero no la visité yo mismo).
- La pantalla de carga mientras se resuelve un token guardado.
- Cerrar sesión localmente cuando el servidor no responde (en el flujo de cerrar sesión, no
  en el de validar un token al arrancar — ese sí lo comprobé parando y levantando el
  backend).

### 2. Las incoherencias que aparecieron al escribirla

- El cierre de sesión del backend responde con un mensaje suelto, sin el mismo envoltorio
  que usan el alta, el inicio de sesión y el perfil — se ve comparando la respuesta real de
  cerrar sesión con las otras tres.
- Hay un middleware que en cada petición comprueba en silencio si quien la hace tiene una
  sesión válida, pero ninguna ruta de esta vertical usa ese resultado para nada — se ve en
  que no hay una sola referencia a esa comprobación fuera de donde se declara.
- El requisito de responder siempre en JSON lo cumple un middleware que corre en **toda**
  ruta del sistema, no solo en esta vertical — se incluye porque los middlewares entraban en
  el alcance acordado, pero no es un comportamiento exclusivo de cuentas y acceso, y merece
  decirlo en vez de callarlo.
- La verificación de email duplicado distingue mayúsculas de minúsculas, pero nada en el
  producto comunica esa regla — dos personas podrían terminar con cuentas distintas por una
  mayúscula sin querer, y no hay forma de que lo sepan de antemano.

### 3. Lo que no pude decidir si era un bug o el contrato

Una primera versión de esta spec decía que, ante un fallo no explícito al validar un token
guardado, lo que ve la persona era "indistinguible" de un rechazo real. Comprobarlo de
verdad (parar el backend, mirar qué queda en `localStorage`, y volver a arrancarlo) demostró
que eso era falso: el mensaje en pantalla es distinto ("no se pudo conectar" frente a
"sesión caducada") y la sesión se recupera sola al recargar en un caso y no en el otro — sí
es observable, así que ya está escrito arriba como spec y no como duda.

Lo que sigue sin decidirse es más fino: durante ese fallo, la persona ve el formulario de
login completo, como si tuviera que volver a escribir sus credenciales — cuando en realidad
su token seguía siendo válido y bastaba con esperar o recargar. Una lectura: es una
simplificación deliberada, total, no hacía falta construir una tercera pantalla para un
corte de red pasajero. La otra lectura: es un descuido, y alguien que vea ese formulario va
a escribir su contraseña otra vez, abriendo una sesión nueva innecesaria en vez de esperar a
la que ya tenía. No hay señal en el código de que se haya pensado esta diferencia a
propósito.

Un segundo caso: cuando no hay nombre completo, las iniciales de una cuenta salen de tomar
la primera letra de la parte del email antes de la arroba y la primera letra de después de
la arroba (por ejemplo, `ana@trabajo.com` da "AT"). Esto usa el mismo patrón de código que
separa un nombre completo en sus dos primeras palabras, aplicado a un email en vez de a un
nombre — lo que sugiere que es una reutilización accidental del mismo gesto, no una
decisión pensada para este caso. Que existan además dos reglas más (nombre de una palabra →
sus dos primeras letras; nombre de dos o más palabras → la primera y la *segunda*, no la
última, como se pensaba en la primera versión de esta spec) refuerza esta lectura: son tres
reglas distintas que parecen una única función genérica reutilizada tres veces, no tres
decisiones de producto independientes. No encontré ninguna señal en el código que confirme
si alguien decidió estos resultados a propósito o si simplemente salieron así de reusar la
misma lógica.
