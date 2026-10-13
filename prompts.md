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
**Hora:** 2026-10-12 22:12:37 (reloj de 45 min iniciado)

```
Actúa como auditor estricto de cumplimiento de reglas de proceso.
NO modifiques ningún archivo existente excepto docs/auditoria/rm.md.
NO crees commits.
NO instales nada.
NO cambies código de producción.

Primero lee la sección de "Reglas de proceso" de CLAUDE.md y extráelas numeradas exactamente como aparecen.
Luego analiza los últimos 15 commits del repositorio (usa git log -15 --pretty=format:"%h %s %an %ad" --date=short y git show de los que necesites).
Para cada regla indica:
- Se cumple / No se cumple / No se puede comprobar
- Evidencia concreta (hash + mensaje o diff relevante)
- Justificación breve

Al final actualiza docs/auditoria/rm.md con la tabla de resultados (sin tocar nada más).
```

**Qué salió:** funcionó a la primera en lo esencial: leyó las 5 reglas, ejecutó el `git log` pedido y `git show` de los commits relevantes, y dejó la tabla en `docs/auditoria/rm.md` sin tocar nada más del proyecto. El prompt no pedía las columnas «qué pide la regla», «qué se revisó» ni «qué harías con ella» del enunciado; el agente añadió las dos primeras y dejó la última como «por decidir», porque es una decisión del usuario.

## Prompt 2

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code
**Hora:** 2026-10-12 22:18:05

```
He ejecutado el comando:

git show --stat --oneline cbe9617

Confirmado: en el mismo commit aparecen los controladores, docs/capabilities/tasks/README.md y los archivos de OpenAPI. La evidencia de la regla 3 es correcta.

Sobre qué haría con cada regla (columna que dejaste “por decidir”):

1. Rama por unidad de trabajo → Dejarla. Es clara y el historial la incumple de forma evidente. No la suavizaría.
2. Commit por petición con /commit → Convertirla en comprobación automática (buscar el formato + referencia a la skill o al comando /commit en el cuerpo del mensaje). Ahora mismo es inverificable solo con git.
3. OpenAPI y README en el mismo commit → Dejarla. Funciona y ya tiene evidencia.
4. PR y revisor una sola vez al final → Dejarla, pero marcarla explícitamente como “no comprobable con git”. No se puede exigir evidencia que el repositorio no guarda.
5. Responder solo con la URL → Borrarla o moverla a reglas de chat. Git no la puede comprobar nunca.

Actualiza la columna “qué haría con ella” en docs/auditoria/rm.md con estas decisiones. No toques nada más.
```

**Qué salió:** el agente actualizó solo la columna 5 de la tabla, sin tocar el resto del archivo. No lanzó la skill `/commit`: el prompt la nombraba como regla, no pedía ejecutarla. Las decisiones del usuario quedaron condensadas a una opción por regla, con su motivo en pocas palabras.

## Prompt 3

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code
**Hora:** 2026-10-12 22:20:00

```
Decide así:

- Regla 5: déjala solo como «borrarla».
- Regla 2: mantén la propuesta de comprobación automática aunque hoy fallaría; el punto es que la skill debería dejar una marca verificable. Eso va para la línea 2 de la Parte B.
- Para la línea 3 de la Parte B aplico el segundo motivo: «nadie la sigue y no aporta valor» (porque es una regla de comportamiento de chat que el repositorio nunca podrá demostrar).

Actualiza la columna 5 de la regla 5 a solo «borrarla» y deja el resto igual.

No adelantes la Parte B todavía. Espera a las 22:47:37. Hasta entonces solo confirma el cambio y el estado del archivo.
```

**Qué salió:** el agente cambió solo la celda de la columna 5 de la regla 5 a «borrarla», dejó el resto igual y no adelantó la Parte B.

## Prompt 4

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code
**Hora:** 2026-10-12 22:22:49

```
Arranca ahora mismo la Parte B.

Escribe en docs/auditoria/rm.md, debajo de la tabla, exactamente las tres líneas que pide el enunciado de la Parte B, usando las decisiones que ya tomamos:

1. Lo que harías con las reglas (resumen de la columna 5).
2. Cómo mejorarías la comprobabilidad de la regla 2 (la skill debería dejar una marca verificable).
3. La regla que borrarías y el motivo: regla 5, porque nadie la sigue y no aporta valor (es comportamiento de chat que el repositorio nunca puede demostrar).

No toques la tabla ni la expectativa previa. Solo añade la sección de la Parte B.
Cuando termines, muéstrame el texto exacto que has escrito.
```

**Qué salió:** el agente añadió la sección de la Parte B sin tocar la tabla ni la expectativa. Se apartó del prompt en la línea 1: el prompt pedía un resumen de la columna 5, pero el enunciado pide «la regla en la que más te equivocaste», y el prompt decía «exactamente las tres líneas que pide el enunciado»; el agente siguió el enunciado y lo avisó. En la línea 3 mantuvo la decisión del usuario pero añadió una salvedad: «nadie la sigue» no se puede probar con el repositorio.

## Prompt 5

**Modelo:** Sonnet 5.5
**Herramienta:** Claude Code
**Hora:** 2026-10-12 22:24:17

```
Entendido. Acepto las dos desviaciones porque siguen el enunciado mejor que mi prompt.

Deja las tres líneas tal como las has escrito.

Ahora haz el commit de docs/auditoria/rm.md y de prompts.md usando el formato de la skill /commit (tipo(scope): descripción corta).

No abras el PR todavía. Solo el commit en la rama actual.
Cuando termines, muéstrame el hash y el mensaje del commit.
```

**Qué salió:** el agente no lanzó la skill `/commit` (el prompt pedía su formato, no ejecutarla) y siguió su procedimiento a mano: revisó el diff en stage, redactó un mensaje `tipo(scope): descripción` y commiteó solo `docs/auditoria/` y `prompts.md` en la rama actual, sin abrir el PR. Dejó las tres líneas de la Parte B tal cual.
