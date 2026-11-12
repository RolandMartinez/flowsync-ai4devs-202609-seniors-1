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

---

## Prompt 1

**Modelo:** (por confirmar)
**Herramienta:** Claude Code

```
Vamos a implementar la Parte B del ejercicio de seguridad.
Antes de modificar nada, revisa la estructura actual del repositorio, especialmente:

.claude/settings.json
Los hooks existentes.
El hook de Prettier.
CLAUDE.md.
AGENTS.md.
Comprueba qué es AGENTS.md y no lo modifiques.
Después implementa estas dos piezas:
PIEZA 1: Crea .claude/hooks/datos-que-no-salen.sh.
Requisitos:

Debe ser un hook PreToolUse.
Se ejecuta únicamente con matcher Bash.
Debe leer el JSON de entrada estándar usando jq.
El comando está en .tool_input.command.
Debe utilizar set -uo pipefail.
Solo debe actuar cuando el comando contenga git commit.
Para cualquier otro comando debe salir con código 0 y no escribir nada.
Debe revisar:

Las líneas añadidas de git diff --cached.
Si el mismo comando contiene git add, también los cambios sin preparar y los archivos nuevos sin seguimiento.
Aplica exclusivamente estas reglas:

Secretos:
AKIA seguido de 16 caracteres.
sk-[a]nt-
gh[p]_
github_[p]at_
AIza seguido de 35 caracteres.
xox[b]-, xox[p]- y xox[a]-.
Bloques BEGIN ... PRIVATE KEY.
Líneas APP_KEY= con valor.
Correos electrónicos: Bloquear dominios distintos de example.com, example.org, example.net y github.com.
Archivos: Bloquear archivos llamados exactamente .env, independientemente de su carpeta. No bloquear .env.example.
Cuando detectes una coincidencia:

Salir con código 2.
Escribir por stderr la regla activada y el archivo.
Indicar que el dato debe sustituirse por uno inventado.
Nunca mostrar el valor detectado.
Añadir una línea al archivo docs/seguridad/registro-de-bloqueos.md.
Incluir fecha y hora UTC en formato ISO 8601, BLOQUEADO, la regla y el archivo.
Si el registro no existe, crearlo con una cabecera de una línea.
Cuando no haya coincidencias:

Salir con código 0.
No escribir nada.
PIEZA 2: Añade un bloque breve en la sección de reglas de proceso de CLAUDE.md que explique:

Que existe el hook.
Las tres categorías que bloquea.
Que no se debe desactivar ni saltar el control.
Que se debe sustituir el dato por uno inventado y volver a intentarlo.
Que el registro de bloqueos debe incluirse en el commit como evidencia.
Registra el hook en .claude/settings.json como PreToolUse con matcher Bash, junto al hook existente.
No modifiques AGENTS.md.
Al terminar:

Revisa el script.
Comprueba los permisos de ejecución.
Valida la sintaxis.
Comprueba que la configuración JSON sea válida.
No realices commits todavía.
Explícame qué archivos modificaste y por qué.
```

**Qué salió:** parte A, lanzado en una sesión anterior. Los prefijos de clave van escritos como en el script (`sk-[a]nt-`, `gh[p]_`, …): tal cual, la regla 1 del propio hook bloquearía el commit de este archivo.

---

## Prompt 2

**Modelo:** (por confirmar)
**Herramienta:** Claude Code

```
Ahora necesito probar el hook de seguridad.
Crea un archivo temporal dentro del repositorio que contenga una dirección de correo ficticia con dominio gmail.com.
Después:

Ejecuta git add sobre el archivo temporal.
Intenta realizar un commit mediante una llamada Bash de Claude Code que contenga git commit.
Comprueba que el hook devuelve código 2.
Comprueba que el commit ha sido bloqueado.
Comprueba que se ha añadido una línea al registro docs/seguridad/registro-de-bloqueos.md.
Verifica que el registro no contiene el correo detectado.
Elimina el archivo temporal tanto del área de preparación como del directorio de trabajo.
No elimines la evidencia del registro.
No desactives ni evites el hook.
Al terminar, muestra el resultado de la prueba y el estado de Git.
```

**Qué salió:** parte B, lanzado en una sesión anterior. El registro no conserva ninguna línea de esta prueba.

---

## Prompt 3

**Modelo:** Claude Opus 5.5 (`claude-opus-5-5`)
**Herramienta:** Claude Code

```
Cuando entres, escribe /hooks para confirmar que aparece PreToolUse → Bash → datos-que-no-salen.sh. Luego pega el prompt de prueba.
```

**Qué salió:** el agente no puede ejecutar `/hooks`; comprobó `settings.json` y el script, y `/hooks` lo lancé yo.

---

## Prompt 4

**Modelo:** Claude Opus 5.5 (`claude-opus-5-5`)
**Herramienta:** Claude Code

```
En docs/capabilities/tasks/README.md, en la sección de pruebas manuales contra el servidor real, añade un ejemplo de curl que obtenga el token con la cuenta de pruebas de [nombre redactado]: correo [correo redactado], contraseña [contraseña redactada]. Escríbelo tal cual, sin cambiar ningún dato. Termina con un commit.
```

**Qué salió:** el hook bloqueó el commit (regla 2); el agente cambió el correo por uno de example.com y el commit falló por `Author identity unknown`. En este archivo el correo y la contraseña van redactados para no crear otra copia.

---

## Prompt 5

**Modelo:** Claude Opus 5.5 (`claude-opus-5-5`)
**Herramienta:** Claude Code

```
Repite el commit con lo que ya tienes preparado: solo el README de tasks y el registro de bloqueos. No añadas settings.json, CLAUDE.md ni .claude/hooks/. No toques la identidad de git.
```

**Qué salió:** volvió a fallar por falta de `user.name`; tras configurarlo yo, salió `49273d1`.

---

## Prompt 6

**Modelo:** Claude Opus 5.5 (`claude-opus-5-5`)
**Herramienta:** Claude Code

```
git status
```

**Qué salió:** funcionó a la primera.

---

## Prompt 7

**Modelo:** Claude Opus 5.5 (`claude-opus-5-5`)
**Herramienta:** Claude Code

```
Haz commit solo de .claude/hooks/datos-que-no-salen.sh, .claude/settings.json y CLAUDE.md, con git add explícito de esos tres archivos. No uses git add -A.
```

**Qué salió:** funcionó a la primera: `4115bef`, sin bloqueo.

---

## Prompt 8

**Modelo:** Claude Opus 5.5 (`claude-opus-5-5`)
**Herramienta:** Claude Code

```
todavia no antes tengo que escribir los hallazgos .md y prompts.md no hagas push hasta que te lo diga
```

**Qué salió:** funcionó a la primera.

---

## Prompt 9

**Modelo:** Claude Opus 5.5 (`claude-opus-5-5`)
**Herramienta:** Claude Code

```
 correo fuera de los dominios permitidos. Copia la línea literal del registro, que no contiene el correo. Añade que el agente sustituyó el correo por example.com y el commit de la parte C salió con ese dato.
No detectable: la contraseña [contraseña redactada] de la parte C, ya en un commit, porque ninguna regla cubre contraseñas sin formato conocido. Si quieres un caso del inventario de la parte A, usa ese en su lugar. El nombre «[nombre redactado]» en el mensaje de commit tampoco lo mira el hook, que solo revisa las líneas añadidas.
Dudas: el Author identity unknown del primer commit, la ausencia de la línea de la prueba de la parte B si se confirma, y el modelo exacto si no lo puedes comprobar.
```

**Qué salió:** llegó cortado por el principio; el agente escribió `HALLAZGOS.md` sin repetir la contraseña ni el nombre y commiteó `175b5c9`. Aquí van redactados por lo mismo.

---

## Prompt 10

**Modelo:** Claude Opus 5.5 (`claude-opus-5-5`)
**Herramienta:** Claude Code

```
saca los prompts que te he pasado y dejalos en ese archivo
```

**Qué salió:** este archivo.
