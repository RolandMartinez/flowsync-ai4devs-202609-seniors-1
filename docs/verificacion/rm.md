# Verificación: lo que cada tarea muestra de su responsable

Requisito: «Lo que cada tarea muestra de su responsable» (`openspec/specs/tasks/spec.md`).

## Estimación previa

Anotada el 2026-10-05 a las 22:54:33, antes de abrir la spec o los tests y antes de lanzar el primer prompt.

Escenarios que creía cubiertos: **3**

## Matriz de trazabilidad

Scenarios en el requisito: 3 · Cubiertos: 0

| Escenario | Nombre exacto del test | Estado | Qué faltó (solo si No lo sé) |
|---|---|---|---|
| 1. Responsable identificable: el `assignee` de la tarea trae el nombre ("Ada Lovelace") y las iniciales | ninguno. El más cercano es «un nombre de dos palabras da la inicial de cada una» (`auth/initials.spec.ts`), que comprueba las iniciales "AL" de la cuenta en la respuesta del login, no el `assignee` de una tarea ni el nombre | No cubierto | — |
| 2. La tarea no filtra datos de cuenta: el `assignee` no incluye el email ni otros datos de acceso | ninguno. `backend/tests/functional/tasks/` no existe y ningún test del proyecto menciona `assignee` ni tareas | No cubierto | — |
| 3. Responsable sin nombre: nombre nulo e iniciales presentes en el `assignee`, sin recurrir al email | ninguno. El más cercano es «sin nombre, las iniciales salen del email» (`auth/initials.spec.ts`), que comprueba las iniciales "AE" de una cuenta sin nombre en el login, no el nombre nulo ni el `assignee` | No cubierto | — |

## Parte B: las tres líneas

1. Creía: 3 | Estaban: 0
2. Escenario 2: no supe si “ningún otro dato de acceso” / “ningún otro dato de esa cuenta” incluye el id (hoy el assignee lo lleva) o solo email/password, así que no sé si faltaba un test o faltaba la regla.
3. Decidí que los campos filtrados son email, password, createdAt y updatedAt (permitiendo id), aunque el escenario solo nombraba el email; un campo nuevo que se filtre mañana no haría fallar el test.
