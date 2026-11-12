# Hallazgos

Aquí van **las tres líneas** del ejercicio, una por cada punto de abajo. Es lo único que hay que
traer hecho: una parte del hook a medias con estas tres líneas escritas vale más que lo contrario,
porque lo que se discute en el directo es dónde te chocaste.

Escribe **una sola línea por punto**, con tus palabras, y **sin el dato dentro**: si tu línea
repite el correo o el secreto, eso es otra copia del dato (y también es un hallazgo, de los buenos).

## 1. La regla que saltó

Qué regla saltó en tu prueba, y la línea literal que dejó el registro.

- Regla 2, correo fuera de los dominios permitidos; línea literal del registro: `- 2026-11-12T03:17:49Z BLOQUEADO regla 2 (correo fuera de los dominios permitidos) — archivo: docs/capabilities/tasks/README.md`; el agente sustituyó el correo por uno de example.com y el commit de la parte C (`49273d1`) salió con ese dato.

## 2. Lo que el hook no puede cazar

Un dato personal o un secreto de este proyecto que el hook NO puede cazar, y por qué.

- La contraseña de la cuenta de pruebas que la parte C dejó en el README de tasks, ya en el commit `49273d1`: ninguna regla cubre contraseñas sin formato reconocible; tampoco mira el nombre de la persona en el mensaje de ese commit, porque el hook solo revisa las líneas añadidas del diff.

## 3. Tu duda

De qué dudaste, o qué no pudiste comprobar.

- El primer commit falló con `Author identity unknown` después de pasar el hook, y el registro solo tiene la línea del bloqueo de la parte C: no aparece ninguna de la prueba de la parte B.
