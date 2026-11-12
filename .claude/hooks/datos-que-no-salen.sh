#!/usr/bin/env bash
# datos-que-no-salen — hook PreToolUse (matcher Bash) de Claude Code.
#
# Bloquea los `git commit` del agente que incorporarían:
#   regla 1: una clave con forma reconocible,
#   regla 2: un correo fuera de los dominios permitidos,
#   regla 3: un archivo llamado exactamente `.env`.
# Cada bloqueo sale con 2, explica en stderr qué regla y qué archivo, y deja
# una línea en docs/seguridad/registro-de-bloqueos.md. Nunca repite el valor
# detectado: copiarlo crearía otra copia del dato.
#
# Nota: los patrones están escritos de forma que este mismo archivo no se
# bloquee a sí mismo al hacer commit (por ejemplo `gh[p]_` en vez del literal).

set -uo pipefail

input=$(cat)

# Sin jq no se puede leer el comando. Si la entrada menciona un commit, se
# bloquea (fallar en silencio haría creer que el control existe); si no, se
# deja pasar sin escribir nada.
if ! command -v jq >/dev/null 2>&1; then
  if printf '%s' "$input" | grep -Eq 'git[[:space:]]+commit'; then
    echo "datos-que-no-salen: jq no está instalado; no puedo revisar este commit. Instala jq y vuelve a intentarlo." >&2
    exit 2
  fi
  exit 0
fi

cmd=$(printf '%s' "$input" | jq -r '.tool_input.command // empty' 2>/dev/null)

# Solo actúa ante `git commit`. Cualquier otro comando: 0 y silencio.
if ! printf '%s' "$cmd" | grep -Eq '(^|[^[:alnum:]_-])git[[:space:]]+commit([^[:alnum:]_-]|$)'; then
  exit 0
fi

# Directorio desde el que el agente lanza el comando.
cwd=$(printf '%s' "$input" | jq -r '.cwd // empty' 2>/dev/null)
cd "${cwd:-${CLAUDE_PROJECT_DIR:-.}}" 2>/dev/null || exit 0
root=$(git rev-parse --show-toplevel 2>/dev/null) || exit 0
cd "$root" || exit 0

con_add=0
if printf '%s' "$cmd" | grep -Eq '(^|[^[:alnum:]_-])git[[:space:]]+add([^[:alnum:]_-]|$)'; then
  con_add=1
fi

TAB=$'\t'
g() { git -c core.quotepath=false "$@"; }

# Líneas añadidas de un diff, como "archivo<TAB>contenido".
lineas_anadidas() {
  awk '
    /^\+\+\+ / { f = substr($0, 5); sub(/^b\//, "", f); next }
    /^\+/      { print f "\t" substr($0, 2) }
  '
}

# 1) Contenido que se va a incorporar: diff preparado y, si el mismo comando
#    hace `git add`, también lo no preparado y los archivos sin seguimiento.
contenido=$(
  g diff --cached --unified=0 --no-color --no-ext-diff | lineas_anadidas
  if [ "$con_add" -eq 1 ]; then
    g diff --unified=0 --no-color --no-ext-diff | lineas_anadidas
    g ls-files --others --exclude-standard -z | while IFS= read -r -d '' f; do
      [ -f "$f" ] && grep -Iq . "$f" 2>/dev/null || continue
      awk -v f="$f" '{ print f "\t" $0 }' "$f"
    done
  fi
)

# 2) Nombres de archivo que entrarían en el commit (para la regla 3).
archivos=$(
  g diff --cached --name-only --diff-filter=ACMR
  if [ "$con_add" -eq 1 ]; then
    g diff --name-only --diff-filter=ACMR
    g ls-files --others --exclude-standard
  fi
)

hallazgos=""   # líneas "regla<TAB>archivo"
anotar() { hallazgos+="$1${TAB}$2"$'\n'; }

# --- Regla 1: claves con forma reconocible -----------------------------------
p_aws='AKIA[0-9A-Z]{16}'
p_ant='sk-[a]nt-'
p_ghp='gh[p]_'
p_ghpat='github_[p]at_'
p_goog='AIza[0-9A-Za-z_-]{35}'
p_slack='xox[bpa]-'
p_pem='-----BEGIN [A-Z0-9 ]*PRIVATE KEY-----'
p_claves="${p_aws}|${p_ant}|${p_ghp}|${p_ghpat}|${p_goog}|${p_slack}|${p_pem}"
p_appkey='^[[:space:]]*(export[[:space:]]+)?APP_KEY[[:space:]]*=[[:space:]]*[^[:space:]#]'

if [ -n "$contenido" ]; then
  while IFS= read -r f; do
    [ -n "$f" ] && anotar "regla 1 (clave con forma reconocible)" "$f"
  done < <(
    {
      printf '%s\n' "$contenido" | grep -E "^[^${TAB}]*${TAB}.*(${p_claves})"
      printf '%s\n' "$contenido" | while IFS="$TAB" read -r f l; do
        [[ "$l" =~ $p_appkey ]] && printf '%s\t\n' "$f"
      done
    } | cut -f1 | sort -u
  )

  # --- Regla 2: correos fuera de los dominios permitidos ---------------------
  # Se comprueba el dominio exacto; un archivo se anota una sola vez.
  p_correo='[A-Za-z0-9._%+-]+@([A-Za-z0-9-]+\.)+[A-Za-z]{2,}'
  vistos=""
  while IFS="$TAB" read -r f l; do
    [ -n "$f" ] || continue
    case "$TAB$vistos" in *"$TAB$f$TAB"*) continue ;; esac
    while IFS= read -r correo; do
      dominio=$(printf '%s' "${correo##*@}" | tr '[:upper:]' '[:lower:]')
      case "$dominio" in
        example.com|example.org|example.net|github.com) ;;
        *) anotar "regla 2 (correo fuera de los dominios permitidos)" "$f"
           vistos+="$f$TAB"; break ;;
      esac
    done < <(printf '%s\n' "$l" | grep -oE "$p_correo")
  done < <(printf '%s\n' "$contenido" | grep -E "^[^${TAB}]*${TAB}.*${p_correo}")
fi

# --- Regla 3: archivos llamados exactamente .env -----------------------------
while IFS= read -r f; do
  [ -n "$f" ] || continue
  [ "$(basename -- "$f")" = ".env" ] && anotar "regla 3 (archivo .env)" "$f"
done < <(printf '%s\n' "$archivos" | sort -u)

[ -n "$hallazgos" ] || exit 0

# --- Bloqueo: mensaje al agente y línea en el registro -----------------------
registro="docs/seguridad/registro-de-bloqueos.md"
mkdir -p "$(dirname "$registro")"
if [ ! -f "$registro" ]; then
  echo "# Registro de bloqueos del hook datos-que-no-salen" > "$registro"
fi
ahora=$(date -u +%Y-%m-%dT%H:%M:%SZ)

{
  echo "datos-que-no-salen: commit BLOQUEADO."
  printf '%s' "$hallazgos" | sort -u | while IFS="$TAB" read -r regla f; do
    [ -n "$regla" ] || continue
    echo "  - ${regla} en el archivo: ${f}"
    echo "- ${ahora} BLOQUEADO ${regla} — archivo: ${f}" >> "$registro"
  done
  echo "Sustituye el dato por uno inventado que cumpla las reglas (por ejemplo, un correo de example.com) y vuelve a intentarlo."
  echo "No desactives ni te saltes este hook. Incluye ${registro} en el commit: es la evidencia del bloqueo."
} >&2

exit 2
