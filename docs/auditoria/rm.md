# Auditoría de las reglas de proceso

Reglas de proceso de `CLAUDE.md` (sección `## Reglas de proceso`), contrastadas con los últimos 15 commits de `s5/start`.

## Expectativa previa

Anotada el 2026-10-12 a las 22:07:57, antes de revisar el historial y antes de lanzar el primer prompt. Pregunta: ¿se está cumpliendo la regla? (sí, no o ni idea).

| Regla | Expectativa |
|---|---|
| 1. Rama por unidad de trabajo; nunca commitear directo en `main` ni en una `sN/*` | no |
| 2. Commit por petición, con la skill `/commit` | no |
| 3. OpenAPI y README de la capability al día en el mismo commit | no |
| 4. `gh pr create` y `adversarial-reviewer` una sola vez, al terminar | ni idea |
| 5. Al abrir el PR, responder solo con la URL | no |

## Tabla de la auditoría

Contrastada con los últimos 15 commits de `s5/start` (de `a3bb962` a `b955a72`) y con el estado actual de los archivos. Auditoría de solo lectura: no se modificó ningún archivo del proyecto.

| Qué pide la regla | Qué se revisó | Veredicto | Evidencia | Qué harías con ella |
|---|---|---|---|---|
| 1. Trabajar en una rama por unidad de trabajo (no por petición) y no commitear nunca directo en `main` ni en una `sN/*`. | `git log -15` con el formato pedido, `git log -15 --merges`, `git log -15 --graph --decorate`, `git show -s` de cada commit. | no se cumple | `afc4b74` y `b955a72` dicen en su mensaje «en la rama de partida» (`s5/start` y `s4/start`), y `21ce54d` y `a3bb962` son los últimos commits de `s5/start`; historial lineal, sin merges entre los 15. La mitad «una rama por unidad de trabajo» no se puede comprobar: git no guarda nombres de rama. | dejarla (es clara; no la suavizaría) |
| 2. Hacer un commit por cada petición, usando la skill `/commit`. | `git log -15` (formato de los mensajes), `git show -s` de cada uno y `.claude/skills/commit/SKILL.md`. | no se puede comprobar con la información disponible | La skill solo deja como huella el formato `tipo(scope): descripción`: 14 de los 15 lo cumplen (`a3bb962` no lleva scope), pero un commit hecho a mano dejaría la misma huella y no hay registro de que se invocara la skill; además 12 de los 15 llevan cuerpo largo y `Co-Authored-By`, algo que el procedimiento de la skill no prescribe. | convertirla en comprobación automática: buscar el formato `tipo(scope)` y una referencia a la skill o a `/commit` en el cuerpo del mensaje |
| 3. Si un cambio toca rutas, controladores, validadores o transformers de una capability, dejar en el mismo commit el OpenAPI y el README de la capability al día. | `git log -15 --name-only`, `git show -s` de `cbe9617`, `4e03d1f` y `ea5db1f`, y lectura de `docs/capabilities/tasks/README.md`, `backend/app/openapi/schemas.ts` y `task_transformer.ts` (estado actual). | se cumple | `cbe9617`, el único commit posterior a la regla (`160fbc7`) que toca controladores, cambia en el mismo commit `docs/capabilities/tasks/README.md` y los esquemas OpenAPI, y hoy ambos describen el `assignee` igual que el transformer. Reservas: `4e03d1f` (transformer sin README) y `ea5db1f` son anteriores a la regla, y el diff de `.adonisjs/` no se pudo verificar sin regenerarlo. | dejarla (funciona y ya tiene evidencia) |
| 4. Abrir el PR con `gh pr create` y pasar `adversarial-reviewer` una sola vez, al terminar la unidad de trabajo, con el review como último paso. | `git log -15` (mensajes y cuerpos) y búsqueda de «pull request», `gh pr`, `#número`, «adversarial» y «reviewer». | no se puede comprobar con la información disponible | Ningún commit registra la creación de un PR ni un pase del revisor: solo `8f9e715` (configura al revisor) y `0e56705` (escribe la regla) lo mencionan; faltan los datos del PR en GitHub (fechas, número de PRs, comentarios del revisor). | dejarla, marcada como «no comprobable con git»: no se puede exigir evidencia que el repositorio no guarda |
| 5. Al abrir el PR, no repetir el resumen en el chat: responder solo con la URL. | `git log -15` (mensajes y cuerpos) y lista de archivos tocados por cada commit. | no se puede comprobar con la información disponible | Es un comportamiento del chat: ni git ni los archivos guardan lo que responde el agente; falta el transcript de la sesión. | borrarla |

## Parte B: las tres líneas

1. La regla en la que más me equivoqué fue la 3: esperaba que no se cumpliera y el veredicto es «se cumple», porque `cbe9617` deja el README y el OpenAPI de `tasks` al día en el mismo commit que toca los controladores (aunque es el único commit posterior a la regla que lo demuestra).
2. La regla 2 (commit por petición con `/commit`) no se puede comprobar porque la skill no deja otra huella que el formato del mensaje; para verificarla, la skill debería dejar una marca verificable (por ejemplo, un trailer fijo en cada commit) y la regla convertirse en una comprobación automática que la busque, aunque hoy ningún commit la lleva y fallaría.
3. Borraría la regla 5 por el segundo motivo (nadie la sigue y no aporta valor), con una salvedad: no puedo probar que nadie la siga, porque es comportamiento de chat que el repositorio no guarda, y por eso mismo la regla no aporta nada verificable.
