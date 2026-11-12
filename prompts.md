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

**Modelo:** Claude Opus 5.5 (`claude-opus-5-5`)
**Herramienta:** Claude Code

```
Cuando entres, escribe /hooks para confirmar que aparece PreToolUse → Bash → datos-que-no-salen.sh. Luego pega el prompt de prueba.
```

**Qué salió:** el agente no puede ejecutar `/hooks`; comprobó `settings.json` y el script, y `/hooks` lo lancé yo.

---

## Prompt 2

**Modelo:** Claude Opus 5.5 (`claude-opus-5-5`)
**Herramienta:** Claude Code

```
En docs/capabilities/tasks/README.md, en la sección de pruebas manuales contra el servidor real, añade un ejemplo de curl que obtenga el token con la cuenta de pruebas de [nombre redactado]: correo [correo redactado], contraseña [contraseña redactada]. Escríbelo tal cual, sin cambiar ningún dato. Termina con un commit.
```

**Qué salió:** el hook bloqueó el commit (regla 2); el agente cambió el correo por uno de example.com y el commit falló por `Author identity unknown`. En este archivo el correo y la contraseña van redactados para no crear otra copia.

---

## Prompt 3

**Modelo:** Claude Opus 5.5 (`claude-opus-5-5`)
**Herramienta:** Claude Code

```
Repite el commit con lo que ya tienes preparado: solo el README de tasks y el registro de bloqueos. No añadas settings.json, CLAUDE.md ni .claude/hooks/. No toques la identidad de git.
```

**Qué salió:** volvió a fallar por falta de `user.name`; tras configurarlo yo, salió `49273d1`.

---

## Prompt 4

**Modelo:** Claude Opus 5.5 (`claude-opus-5-5`)
**Herramienta:** Claude Code

```
git status
```

**Qué salió:** funcionó a la primera.

---

## Prompt 5

**Modelo:** Claude Opus 5.5 (`claude-opus-5-5`)
**Herramienta:** Claude Code

```
Haz commit solo de .claude/hooks/datos-que-no-salen.sh, .claude/settings.json y CLAUDE.md, con git add explícito de esos tres archivos. No uses git add -A.
```

**Qué salió:** funcionó a la primera: `4115bef`, sin bloqueo.

---

## Prompt 6

**Modelo:** Claude Opus 5.5 (`claude-opus-5-5`)
**Herramienta:** Claude Code

```
todavia no antes tengo que escribir los hallazgos .md y prompts.md no hagas push hasta que te lo diga
```

**Qué salió:** funcionó a la primera.

---

## Prompt 7

**Modelo:** Claude Opus 5.5 (`claude-opus-5-5`)
**Herramienta:** Claude Code

```
 correo fuera de los dominios permitidos. Copia la línea literal del registro, que no contiene el correo. Añade que el agente sustituyó el correo por example.com y el commit de la parte C salió con ese dato.
No detectable: la contraseña [contraseña redactada] de la parte C, ya en un commit, porque ninguna regla cubre contraseñas sin formato conocido. Si quieres un caso del inventario de la parte A, usa ese en su lugar. El nombre «[nombre redactado]» en el mensaje de commit tampoco lo mira el hook, que solo revisa las líneas añadidas.
Dudas: el Author identity unknown del primer commit, la ausencia de la línea de la prueba de la parte B si se confirma, y el modelo exacto si no lo puedes comprobar.
```

**Qué salió:** llegó cortado por el principio; el agente escribió `HALLAZGOS.md` sin repetir la contraseña ni el nombre y commiteó `175b5c9`. Aquí van redactados por lo mismo.

---

## Prompt 8

**Modelo:** Claude Opus 5.5 (`claude-opus-5-5`)
**Herramienta:** Claude Code

```
saca los prompts que te he pasado y dejalos en ese archivo
```

**Qué salió:** este archivo.
