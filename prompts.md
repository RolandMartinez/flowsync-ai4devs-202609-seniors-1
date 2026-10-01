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

**Modelo:** Sonnet 5
**Herramienta:** Claude Code
**Hora:** 2026-09-30 20:56:53 (reloj de 45 min iniciado)

```
Abre el vertical de cuentas y acceso (backend: rutas, controladores, modelo de usuario,
validadores, middlewares — incluidos los transversales force_json_response_middleware y
silent_auth_middleware; frontend: pantallas de acceso, estado de sesión, protección de
rutas) y escribe la spec de lo que el sistema hace HOY. No propongas nada, no cambies una
línea. Formato: ## Purpose, ## Requirements con ### Requirement: SHALL, cada uno con al
menos un #### Scenario: con WHEN/THEN. Nada de ADDED/MODIFIED/REMOVED. Solo comportamiento
observable desde fuera (API: petición/respuesta; pantalla: lo que una persona ve y puede
hacer) — nada de nombres de clase ni de archivo. Durante el resto del reloj, comprueba cada
requisito contra el código real (abrir y mirar, no solo que suene razonable). Para cuando
suene el reloj, aunque esté a medias.
```

**Qué salió:** funcionó a la primera en cuanto a formato (Purpose/Requirements/Scenario correctos a la primera), pero tuve que hacer pruebas reales contra el backend (curl) y contra el frontend en navegador (signup, login, logout, tokens inválidos inyectados a mano) para poder marcar "comprobado" de verdad en vez de solo leer el código — eso se llevó la mayor parte del tiempo. Primera versión: conteo de requisitos mal hecho (decía 16 cuando el archivo tenía 15), y dos huecos reales de cobertura — ver Prompt 2.

## Prompt 2

**Modelo:** Sonnet 5
**Herramienta:** Claude Code
**Hora:** 2026-09-30 21:04 aprox.

```
Se un experto en aquitectura , revísalo línea por línea antes de seguir
```

**Qué salió:** encontró 2 fallos reales de cobertura (iniciales de nombre de una sola
palabra sin requisito ni comprobar; "crear cuenta" sin escenario del caso base con nombre),
un "comprobado" sobregeneralizado (login vs. registro), una tensión de alcance sin nombrar
(el requisito de JSON lo cumple un middleware que corre en todo el sistema, no solo en esta
vertical), comentarios de la Parte B filtrados dentro de la Parte A, y el propio error de
conteo mencionado arriba. Ninguno de estos fallos los había visto yo al escribir la primera
versión — salieron todos al pedir la revisión estricta, no al redactar.

## Prompt 3

**Modelo:** Sonnet 5
**Herramienta:** Claude Code
**Hora:** 2026-09-30 21:11 aprox.

```
Sí, aplica los 6 arreglos se riguroso en la solucion
```

**Qué salió:** probé en vivo los dos casos que faltaban (nombre de una sola palabra →
"Madonna" da "MA"; caso base con nombre → "Ana Garcia" da "AG") antes de escribir sus
requisitos, en vez de asumir el resultado. Recalculé los números con el conteo correcto:
16 requisitos escritos (15 originales + 1 nuevo), 13 comprobados — misma cifra final que
antes, pero esta vez aritméticamente consistente con la lista real, no por coincidencia.

## Prompt 4

**Modelo:** Sonnet 5
**Herramienta:** Claude Code
**Hora:** 2026-09-30 21:17 aprox.

```
sí, prueba los 3 y añádelos
```
(aprobando mi propia sugerencia de 3 escenarios nuevos: logout no-global, email mal
formado, contraseña corta — ver mensaje anterior)

**Qué salió:** los tres se confirmaron en vivo contra el backend real antes de escribirlos:
logout con un token no invalida el otro token activo de la misma cuenta (hallazgo de
seguridad real, no documentado hasta ahora); email mal formado y contraseña corta rechazan
con 422 y mensajes específicos. Bonus no buscado: la contraseña corta devuelve dos errores
a la vez (password y passwordConfirmation), confirmando que el array de errores soporta
más de uno simultáneo. 19 requisitos escritos, 23 escenarios, 16 comprobados — verificado
con `grep`, no de memoria.
