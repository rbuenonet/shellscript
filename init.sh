# ---------------------------------------------
# Inicializador de ambiente bash customizado
# 
# 
# 
# Carrega configurações do projeto
# [ -f ~/seu-projeto/bash/init.sh ] && source ~/seu-projeto/bash/init.sh
# ---------------------------------------------

# Define o diretório base (raiz do projeto)
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Carrega arquivos da pasta core
[ -f "$BASE_DIR/core/alias.sh" ]      && source "$BASE_DIR/core/alias.sh"
[ -f "$BASE_DIR/core/functions.sh" ]  && source "$BASE_DIR/core/functions.sh"
[ -f "$BASE_DIR/core/utils.sh" ]      && source "$BASE_DIR/core/utils.sh"

# Carrega arquivos da pasta modules
MODULES_DIR="$BASE_DIR/modules"
if [ -d "$MODULES_DIR" ]; then
  for file in "$MODULES_DIR"/*.sh; do
    [ -f "$file" ] && source "$file"
  done
fi

# Carrega arquivos da pasta config
CONFIG_DIR="$BASE_DIR/config"
if [ -d "$CONFIG_DIR" ]; then
  for file in "$CONFIG_DIR"/*.sh; do
    [ -f "$file" ] && source "$file"
  done
fi