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
  echo -e "[INFO]${NOCOLOR} $1"
}

log_error() {
  echo -e "${RED}[INFO]${NOCOLOR} $1"
}

log_warning() {
  echo -e "${YELLOW}[INFO]${NOCOLOR} $1"
}

log_success() {
  echo -e "${GREEN} [INFO]${NOCOLOR} $1"
}

# Crea una lista con los distintos challenges de la unidad
folder_name=$(basename "$(pwd)")
log_info "Obteniendo lista de challenges de la unidad ${folder_name}"
challenges=(*)

# Itero sobre la lista
for challenge in "${challenges[@]}"; do
  if [ -d "$challenge/.git" ]; then
    log_info "Procesando challenge (repo Git): ${challenge}"

    cd "${challenge}" || continue

    if git status --porcelain | grep --quiet ".ipynb"; then
      log_info "Se encontraron cambios para pushear!"
      git add *.ipynb
      git commit -m "Subiendo notebook de ${folder_name}/${challenge}"

      push_output=$(git push origin master 2>&1)
      if git push origin master; then
        log_success "Subida exitosa a GitHub del challenge ${challenge}"
      else
        log_error "Falló el push. Debido al siguiente error:"
        echo "${push_output}"
      fi
    else
      log_info "No hay cambios pendientes en este challenge"
    fi
  else
    log_warning "Saltando: ${challenge} (no es un repo de Git)"
  fi
  cd ..
done

log_success "===== Proceso completado ====="
