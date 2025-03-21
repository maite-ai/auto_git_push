#!/bin/bash

# Estilos
BOLD='\e[1m'
UNDERLINE='\e[4m'

# Colores semáforo para mensajes
RED='\033[0;31m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'

# Otros colores
BLUE='\033[0;34m'
NOCOLOR='\033[0m' # para resetear color

# Funciones para imprimir con colorcito ;)
log_info() {
  echo -e "${BLUE}[INFO]${NOCOLOR} $1"
}

log_error() {
  echo -e "${RED}[ERROR] $1${NOCOLOR}"
}

log_warning() {
  echo -e "${YELLOW}[WARNING]${NOCOLOR} $1"
}

log_success() {
  echo -e "${GREEN}[SUCCESS] $1${NOCOLOR}"
}

# Crea una lista con los distintos challenges de la unidad
folder_name=$(basename "$(pwd)")
echo -e "${UNDERLINE}Obteniendo lista de challenges de la unidad ${folder_name}${NOCOLOR}"
challenges=(*)

# Itero sobre la lista
for challenge in "${challenges[@]}"; do
  if [ -d "$challenge/.git" ]; then
    log_info "Procesando challenge (repo Git): ${challenge}"
    cd "${challenge}" || continue

    if git status --porcelain | grep --quiet ".ipynb"; then
      log_info "Se encontraron cambios para pushear!"
      git add *.ipynb
      git commit -m "Uploading ${folder_name}/${challenge} notebook"

      push_output=$(git push origin master 2>&1)
      if git push origin master; then
        log_success "Subida exitosa del challenge ${challenge} a GitHub"
      else
        log_error "Falló la subida debido al siguiente error:"
        echo "${push_output}"
      fi
    else
      log_info "No hay cambios pendientes en este challenge"
    fi
  else
    log_warning "Saltando: ${challenge} (no es un repo de Git)"
  fi
  cd ..
  echo ""
done

echo -e "${BOLD}===== Proceso completado =====${NOCOLOR}"
