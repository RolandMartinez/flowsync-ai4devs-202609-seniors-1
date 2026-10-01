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
- **THEN** la cuenta se crea con ese nombre, y la respuesta incluye los datos del usuario y
  un token de acceso

#### Scenario: Alta con nombre completo omitido
- **WHEN** se envía un alta con un email no registrado, contraseña y confirmación
  coincidentes, y sin nombre completo
- **THEN** la cuenta se crea, el nombre queda vacío, y la respuesta incluye los datos del
  usuario y un token de acceso

### Requirement: Rechazar un email ya registrado
El sistema SHALL rechazar un alta cuyo email ya pertenezca a una cuenta existente.

#### Scenario: Email duplicado
- **WHEN** se envía un alta con un email que ya tiene cuenta
- **THEN** la petición se rechaza y la respuesta señala el campo del email como la causa

### Requirement: Exigir confirmación de contraseña
El sistema SHALL rechazar un alta cuando la contraseña y su confirmación no coinciden.

#### Scenario: Confirmación distinta
- **WHEN** la confirmación de contraseña no coincide con la contraseña
- **THEN** la petición se rechaza y la respuesta señala el campo de confirmación como la causa

### Requirement: Rechazar un email con formato inválido
El sistema SHALL rechazar un alta cuando el email no tiene forma de email.

#### Scenario: Email mal formado
- **WHEN** se envía un alta con un texto que no tiene forma de email
- **THEN** la petición se rechaza y la respuesta señala el campo del email como la causa

### Requirement: Exigir una longitud mínima de contraseña
El sistema SHALL rechazar un alta cuando la contraseña tiene menos de 8 caracteres.

#### Scenario: Contraseña demasiado corta
- **WHEN** se envía un alta con una contraseña de menos de 8 caracteres (y su confirmación
  igual de corta)
- **THEN** la petición se rechaza señalando tanto el campo de la contraseña como el de su
  confirmación

### Requirement: Iniciar sesión con credenciales correctas
El sistema SHALL autenticar a una persona que envía un email y una contraseña que
coinciden con una cuenta existente, y emitirle un token de acceso nuevo.

#### Scenario: Credenciales correctas
- **WHEN** se envía un email y contraseña que coinciden con una cuenta existente
- **THEN** la respuesta incluye los datos del usuario y un token de acceso nuevo

### Requirement: Rechazar credenciales incorrectas sin distinguir la causa
El sistema SHALL rechazar un intento de inicio de sesión con el mismo mensaje genérico,
tanto si el email no existe como si la contraseña es incorrecta.

#### Scenario: Contraseña incorrecta
- **WHEN** se envía un email de una cuenta existente con una contraseña que no coincide
- **THEN** la petición se rechaza con un mensaje de credenciales inválidas, sin más detalle

#### Scenario: Email inexistente
- **WHEN** se envía un email que no pertenece a ninguna cuenta
- **THEN** la petición se rechaza con el mismo mensaje de credenciales inválidas que una
  contraseña incorrecta

### Requirement: Exigir sesión para ver el perfil
El sistema SHALL exigir un token de acceso válido para devolver los datos de perfil de una
persona.

#### Scenario: Sin token
- **WHEN** se piden los datos de perfil sin un token de acceso
- **THEN** la petición se rechaza por falta de autorización

#### Scenario: Con token válido
- **WHEN** se piden los datos de perfil con un token de acceso vigente
- **THEN** la respuesta incluye los datos de esa cuenta

### Requirement: Mostrar iniciales derivadas de un nombre de dos o más palabras
El sistema SHALL calcular unas iniciales de dos letras a partir del nombre completo de la
cuenta, cuando ese nombre tiene dos o más palabras.

#### Scenario: Nombre con dos o más palabras
- **WHEN** la cuenta tiene un nombre completo con al menos dos palabras
- **THEN** las iniciales son la primera letra de la primera palabra y la primera letra de la
  última, en mayúsculas

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
- **WHEN** se cierra sesión con un token y después se vuelve a usar ese mismo token para
  pedir el perfil
- **THEN** la petición se rechaza por falta de autorización

### Requirement: Cerrar sesión no afecta a otras sesiones activas
El sistema SHALL invalidar únicamente el token con el que se cierra sesión, dejando
intactos los demás tokens activos de la misma cuenta.

#### Scenario: Dos sesiones activas, se cierra una
- **WHEN** una cuenta tiene dos tokens de acceso activos (por ejemplo, dos inicios de
  sesión) y se cierra sesión con uno de ellos
- **THEN** ese token deja de servir, pero el otro sigue dando acceso al perfil con
  normalidad

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

### Requirement: Cerrar la sesión local si el token guardado ya no es válido
El sistema SHALL borrar la sesión guardada y mostrar un aviso explicando el motivo, cuando
el token guardado es rechazado por no ser válido.

#### Scenario: Token guardado inválido al arrancar
- **WHEN** se abre la aplicación con un token guardado que el sistema rechaza por no ser
  válido
- **THEN** la sesión guardada se borra, se muestra la pantalla de inicio de sesión, y en
  ella aparece un aviso explicando que la sesión caducó

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

Requisitos escritos: **19**
Requisitos comprobados (abriendo el código y probando contra el sistema corriendo, no solo
leyendo): **16**

Los 3 escritos y no comprobados en marcha:
- Visitar la pantalla de registro con sesión activa (comparte el mismo guardia de código
  que la de login, que sí comprobé, pero no la visité yo mismo).
- La pantalla de carga mientras se resuelve un token guardado.
- Cerrar sesión localmente cuando el servidor no responde.

### 2. Las incoherencias que aparecieron al escribirla

- El cierre de sesión del backend responde con un mensaje suelto, sin el mismo envoltorio
  que usan el alta, el inicio de sesión y el perfil — se ve comparando la respuesta real de
  cerrar sesión con las otras tres.
- Hay un middleware que en cada petición comprueba en silencio si quien la hace tiene una
  sesión válida, pero ninguna ruta de esta vertical usa ese resultado para nada — se ve en
  que no hay una sola referencia a esa comprobación fuera de donde se declara.
- El código que reacciona cuando falla la validación de un token guardado trae un
  comentario que dice que el token "se conserva" porque "puede seguir siendo bueno"; sin
  embargo, lo que pasa a continuación es indistinguible desde fuera de cuando el token sí
  se descarta: en ambos casos la persona ve la pantalla de inicio de sesión.
- El requisito de responder siempre en JSON lo cumple un middleware que corre en **toda**
  ruta del sistema, no solo en esta vertical — se incluye porque los middlewares entraban en
  el alcance acordado, pero no es un comportamiento exclusivo de cuentas y acceso, y merece
  decirlo en vez de callarlo.

### 3. Lo que no pude decidir si era un bug o el contrato

Cuando la validación de un token guardado falla por algo que no es un rechazo explícito del
servidor (por ejemplo, el servidor no responde), el código dice en un comentario que
conserva el token porque "puede seguir siendo bueno" — pero dos líneas más abajo pone a la
persona en la pantalla de inicio de sesión igual que si el token hubiera sido rechazado de
verdad. Una lectura: el comentario describe la intención original y lo que hace falta es
que la pantalla no empuje a la persona al login en este caso. La otra lectura: lo que
importa es lo que ve la persona, el comentario quedó desactualizado, y el comportamiento
actual (tratarlo igual que un rechazo) es el contrato real. No hay forma de decidir cuál de
las dos es cierta leyendo el código — hace falta preguntar a quien lo escribió.

Un segundo caso, más pequeño: cuando no hay nombre completo, las iniciales de una cuenta
salen de tomar la primera letra de la parte del email antes de la arroba y la primera letra
de después de la arroba (por ejemplo, `ana@trabajo.com` da "AT"). Esto usa exactamente el
mismo patrón de código que separa un nombre completo en dos palabras, aplicado a un email en
vez de a un nombre — lo que sugiere que es una reutilización accidental del mismo gesto, no
una decisión pensada para este caso. Verificar que existe además una tercera regla (nombre
de una sola palabra → sus dos primeras letras) refuerza esta lectura: son tres reglas
distintas que parecen una única función genérica reutilizada, no tres decisiones de
producto independientes. No encontré ninguna señal en el código que confirme si alguien
decidió estos resultados a propósito o si simplemente salieron así de reusar la misma
lógica.
