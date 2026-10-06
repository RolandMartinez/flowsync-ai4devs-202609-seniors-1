# Prompts

Aquí van **todos los prompts que lanzaste** para hacer el ejercicio, en el orden en que los
lanzaste, con el modelo y la herramienta de cada uno.

Esto no es papeleo. Lo que se revisa es **cómo pediste las cosas**, no solo lo que salió: un
resultado flojo con un prompt bueno y un resultado flojo con un prompt vago necesitan feedback
distinto, y sin este archivo no se distinguen.

## Cómo rellenarlo

- Un apartado `## Prompt N` por cada prompt.
- **Pega el prompt tal cual lo lanzaste**, dentro del bloque de código, aunque ocupe diez líneas
  y aunque tenga faltas. No lo reescribas para que quede bien: el que arreglaste mentalmente
  después no es el que lanzaste.
- Incluye también los que **no funcionaron**. Suelen ser los más útiles de leer.
- `Modelo` y `Herramienta` en todos. Si cambiaste de una a otra a mitad, se nota aquí.

Borra el ejemplo de abajo cuando escribas el primero.

---

## Prompt 1

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code
**Hora:** 2026-10-05 22:56:17 (reloj de 45 min iniciado)

```
Abre el archivo openspec/specs/tasks/spec.md.
Localiza ÚNICAMENTE el requisito titulado «Lo que cada tarea muestra de su responsable».
Lista cada escenario de ese requisito (número + descripción en una sola línea).
No abras ningún test todavía.
No propongas tests.
No toques ningún otro archivo.
Devuelve solo la lista numerada de escenarios.
```

**Qué salió:** funcionó a la primera: localizó el requisito y devolvió 3 escenarios (el "4" de la plantilla del enunciado era un ejemplo, no el número real).

## Prompt 2

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code
**Hora:** 2026-10-05 22:59:03

```
1. Responsable identificable: al obtener una tarea cuyo responsable es "Ada Lovelace", su `assignee` trae el nombre y las iniciales, suficientes para saber quién la lleva.
2. La tarea no filtra datos de cuenta: al obtener cualquier tarea (suelta o en la lista), su `assignee` no incluye el email ni ningún otro dato de acceso.
3. Responsable sin nombre: si el responsable se registró sin nombre, su nombre llega nulo y sus iniciales siguen llegando, para representarlo sin recurrir al email.
```

**Qué salió:** no funcionó como prompt: no traía ninguna instrucción, solo la lista pegada de vuelta. El agente pidió aclaración y no tocó nada.

## Prompt 3

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code
**Hora:** 2026-10-05 22:59:44

```
A partir de la lista de escenarios del requisito «Lo que cada tarea muestra de su responsable» que acabas de darme, limpia y numera los escenarios así:

1. Responsable identificable: al obtener una tarea cuyo responsable es "Ada Lovelace", su assignee trae el nombre y las iniciales, suficientes para saber quién la lleva.
2. La tarea no filtra datos de cuenta: al obtener cualquier tarea (suelta o en la lista), su assignee no incluye el email ni ningún otro dato de acceso.
3. Responsable sin nombre: si el responsable se registró sin nombre, su nombre llega nulo y sus iniciales siguen llegando, para representarlo sin recurrir al email.

Ahora construye la matriz de trazabilidad A.1:

1. Abre backend/tests/functional/tasks/ (y subcarpetas si existen).
2. Para CADA uno de los 3 escenarios anteriores:
   - Busca y LEE el contenido completo de los tests que parezcan relacionados (no te fíes solo del nombre del test).
   - Indica el nombre exacto del test (o “ninguno” si no hay ninguno).
   - Marca: Cubierto | No cubierto | No lo sé.
   - Si pusiste “No lo sé”, escribe en una frase qué te faltó para decidir.

Devuelve ÚNICAMENTE una tabla markdown con estas 4 columnas exactas:

| Escenario | Nombre exacto del test | Estado | Qué faltó (solo si No lo sé) |

No escribas ningún test todavía.
No modifiques ningún archivo.
No toques código de producción ni la spec.
La tabla debe caber en una pantalla.
```

**Qué salió:** funcionó a la primera en formato (tabla de 4 columnas). Hallazgo: `backend/tests/functional/tasks/` no existe y ningún test del proyecto menciona `assignee` ni tareas; el agente leyó completo `auth/initials.spec.ts` (lo más cercano) y marcó los 3 escenarios como No cubierto, ninguno como No lo sé.

## Prompt 4

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code
**Hora:** 2026-10-05 23:02:31

```
A partir de la matriz anterior, escribe un test nuevo por cada fila marcada como “No cubierto” (los 3 escenarios).

Reglas estrictas:
- Crea la carpeta backend/tests/functional/tasks/ si no existe.
- Sigue exactamente el estilo de los tests existentes en backend/tests/functional/auth/ (estructura, imports, describe/it, expects, uso de testUtils, etc.).
- Usa los hooks de testUtils para aislar la base de datos (como hacen los tests actuales).
- No toques código de producción, ni la spec, ni ningún otro archivo fuera de backend/tests/.
- No intentes hacer que los tests pasen. Déjalos tal como queden (pueden quedar en rojo).
- Un archivo por escenario o un solo archivo con tres describes/its, elige el estilo que más se parezca a auth/.

Después de escribirlos:
1. Ejecuta solo esos tests nuevos.
2. Muestra el resultado completo (pasan o fallan + el error si fallan).

No hagas nada más.
```

**Qué salió:** funcionó a la primera: un solo archivo, `backend/tests/functional/tasks/assignee.spec.ts`, con 3 tests y el mismo estilo que `auth/`. Resultado: 2 pasan y 1 falla en rojo (el del scenario 2: el `assignee` de la lista lleva `email`). Se dejó en rojo, sin tocar código ni test.

## Prompt 5

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code
**Hora:** 2026-10-05 23:06:30

```
vamos a trabajar en la parte B ..1. Creía: 2 | Estaban: 0
2. Escenario 2 (no filtrar email): no supe si el fallo en la lista se debía a que faltaba el test o a que la spec no dejaba claro el transformer distinto entre tarea suelta y lista.
3. Al escribir el test del email decidí comprobar también la lista (no solo la tarea suelta) y esperar que no exista la propiedad «email», aunque el escenario no especificaba el comportamiento exacto del listado.
```

**Qué salió:** el agente contrastó las tres líneas con los registros y el código: la línea 1 no coincidía con la estimación anotada antes de empezar (3), y las líneas 2 y 3 describían una duda y una decisión que el scenario sí determinaba (nombra la lista de forma explícita). Pidió reformularlas antes de escribirlas en el archivo.

## Prompt 6

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code
**Hora:** 2026-10-05 23:08:32

```
sí, pasa la matriz al archivo
```
(respuesta a la pregunta del agente sobre pasar la matriz de 3 filas, ya devuelta en el chat, a `docs/verificacion/rm.md`)

**Qué salió:** funcionó a la primera: la matriz quedó en el archivo con la cabecera "Scenarios en el requisito: 3 · Cubiertos: 0", las 3 filas y las 4 columnas, igual que en el chat.

## Prompt 7

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code
**Hora:** 2026-10-05 23:12:01

```
1. Creía: 3 | Estaban: 0
```
(la línea 1 de la Parte B, tras corregir el 2 inicial por el 3 que estaba registrado)

**Qué salió:** el agente la escribió tal cual en `docs/verificacion/rm.md`, bajo el encabezado "Parte B: las tres líneas". El 3 coincide con la estimación anotada a las 22:54:33 y el 0 con la matriz.

## Prompt 8

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code
**Hora:** 2026-10-05 23:15:49

```
sí, propónme el borrador de las líneas 2 y 3 pero saca este prompt

Responsable identificable: al obtener una tarea cuyo responsable es "Ada Lovelace", su `assignee` trae el nombre y las iniciales, suficientes para saber quién la lleva.

1. La tarea no filtra datos de cuenta: al obtener cualquier tarea (suelta o en la lista), su `assignee` no incluye el email ni ningún otro dato de acceso.
2. Responsable sin nombre: si el responsable se registró sin nombre, su nombre llega nulo y sus iniciales siguen llegando, para representarlo sin recurrir al email.
```

**Qué salió:** el agente propuso borradores de las líneas 2 y 3, pero la instrucción «saca este prompt» era ambigua (¿quitar un prompt del registro, o usar ese texto como base?). No quitó nada de `prompts.md` y pidió aclararlo. El texto pegado numera los escenarios distinto que la matriz (1 «no filtra», 2 «sin nombre»), y el agente mantuvo la numeración de la matriz.

## Prompt 9

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code
**Hora:** 2026-10-05 23:16:37

```
# Trazabilidad – Responsable de la tarea

Scenarios en el requisito: 3 · Cubiertos: 0

## Matriz A.1

| Escenario                                                                                             | Nombre exacto del test                                                                                                                                                                                                      | Estado      | Qué faltó (solo si No lo sé) |
| ----------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------- | ---------------------------- |
| 1. Responsable identificable: el assignee de la tarea trae el nombre ("Ada Lovelace") y las iniciales | ninguno. El más cercano es «un nombre de dos palabras da la inicial de cada una» (auth/initials.spec.ts), que comprueba las iniciales "AL" de la cuenta en la respuesta del login, no el assignee de una tarea ni el nombre | No cubierto | —                            |
| 2. La tarea no filtra datos de cuenta: el assignee no incluye el email ni otros datos de acceso       | ninguno. backend/tests/functional/tasks/ no existe y ningún test del proyecto menciona assignee ni tareas                                                                                                                   | No cubierto | —                            |
| 3. Responsable sin nombre: nombre nulo e iniciales presentes en el assignee, sin recurrir al email    | ninguno. El más cercano es «sin nombre, las iniciales salen del email» (auth/initials.spec.ts), que comprueba las iniciales "AE" de una cuenta sin nombre en el login, no el nombre nulo ni el assignee                     | No cubierto | —                            |

## Parte B

1. Creía: 3 | Estaban: 0
2. Escenario 2: no supe si “ningún otro dato de acceso” / “ningún otro dato de esa cuenta” incluye el id (hoy el assignee lo lleva) o solo email/password.
3. Decidí que los campos filtrados son email, password, createdAt y updatedAt (permitiendo id), aunque el escenario solo nombraba el email.
```
(mensaje sin instrucción; el agente lo tomó como el contenido final de la Parte B y escribió solo las líneas 2 y 3 en `docs/verificacion/rm.md`, sin reemplazar el archivo)

**Qué salió:** las líneas 2 y 3 quedaron en el archivo con las palabras del usuario. No se sustituyó el archivo entero porque la versión pegada omitía la sección «Estimación previa» con la hora del registro (22:54:33).

## Prompt 10

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code
**Hora:** 2026-10-05 23:18:26

```
2. Escenario 2: no supe si “ningún otro dato de acceso” / “ningún otro dato de esa cuenta” incluye el id (hoy el assignee lo lleva) o solo email/password, así que no sé si faltaba un test o faltaba la regla.
3. Decidí que los campos filtrados son email, password, createdAt y updatedAt (permitiendo id), aunque el escenario solo nombraba el email; un campo nuevo que se filtre mañana no haría fallar el test.
```
(las líneas 2 y 3 reescritas por el usuario con las dos mejoras que propuso el agente)

**Qué salió:** el agente sustituyó en `docs/verificacion/rm.md` solo el final de cada línea, sin tocar el resto del archivo.

## Prompt 11

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code
**Hora:** 2026-10-05 23:19:01

```
pasemos al pr.
```

**Qué salió:** el agente hizo commit solo de `docs/verificacion`, `backend/tests` y `prompts.md`, subió la rama `trazabilidad-rm` a tu fork y abrió el PR contra el repo del curso. Los cambios de `backend/.adonisjs/` y `backend/database/schema.ts` (ruido de saltos de línea) se dejaron fuera.
