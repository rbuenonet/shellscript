# ------------------------------------------------------------------
# Arquivo de funções personalizadas para terminal
# ------------------------------------------------------------------


aliasll() {
    local path="$PATHPROJECT"

    echo "🔧 Funções definidas:"
    grep -hEr '^[a-zA-Z0-9_]+\s*\(\)\s*\{' "$path" | sed 's/^\s*//'

    echo ""

    echo "🔗 Aliases definidos:"
    grep -hEr '^alias\s+[a-zA-Z0-9_]+=.*' "$path" | sed -E "s/^alias\s+([a-zA-Z0-9_]+)=.*(#.*)?/\1 \2/"
}


# Remove arquivos com o nome especificado em todas as subpastas
# Uso: superrm nome_arquivo
superrm() {
    if [ -n "$1" ]; then
        FILE="$1"
        find . -name "$FILE" | while read -r line; do 
            echo "------------------------- Removendo arquivo: $line -------------------------"
            rm "$line"
        done
    else
        echo "❌ Erro: necessário informar o nome do arquivo como parâmetro."
    fi    
}

# Copia um arquivo e cria a pasta de destino, se necessário
# Uso: copy origem destino
copy() {
    ORIGIN="$1"
    DESTINY="$2"

    if [ ! -d "$(dirname "$DESTINY")" ]; then
        mkdir -p "$(dirname "$DESTINY")"
    fi

    cp "$ORIGIN" "$DESTINY"

    echo -e "\n---------------------------------------------------------------------------"
    echo "Arquivo: $ORIGIN"
    echo "Copiado para: $DESTINY"
    echo -e "---------------------------------------------------------------------------\n"
}

# Substitui uma string por outra dentro de um arquivo
# Uso: replace nome_arquivo texto_original novo_texto
replace() {
    FILE="$1"
    SEARCH="$2"
    OBJECT="$3"

    sed -i "" "s/$SEARCH/$OBJECT/g" "$FILE"

    echo -e "\n---------------------------------------------------------------------------"
    echo "Arquivo: $FILE"
    echo "Trocado de: $SEARCH"
    echo "Para: $OBJECT"
    echo -e "---------------------------------------------------------------------------\n"
}

# Função que imprime a estrutura de diretórios e arquivos de forma hierárquica,
# usando emojis para indicar pastas 📁 e arquivos 📄.
# Uso: print_dir_structure <pasta>
# Parâmetros:
#   $1 - Caminho do diretório a ser explorado
#   $2 - Nível de profundidade atual (usado para identação)
print_dir_structure() {
    local dir_path="${1:-.}"     # Usa o parâmetro 1 ou '.' se não fornecido
    local depth="${2:-0}"        # Usa o parâmetro 2 ou '0' se não fornecido
    local indent=$(printf "%*s" $((depth * 2)) "")

    # Array de diretórios a serem ignorados
    local IGNORED_DIRS=("node_modules" ".git")

    for file in "$dir_path"/*; do
        local base_name=$(basename "$file")

        # Verifica se o diretório atual está na lista de ignorados
        for ignored in "${IGNORED_DIRS[@]}"; do
            if [[ "$base_name" == "$ignored" ]]; then
                continue 2  # Pula direto para o próximo item do loop principal
            fi
        done

        if [[ -d "$file" ]]; then
            echo "${indent}📁 $base_name/"
            print_dir_structure "$file" $((depth + 1))
        elif [[ -f "$file" ]]; then
            echo "${indent}📄 $base_name"
        fi
    done
}

# Função que imprime a lista de projetos definidos em PROJETOS e permite selecionar um para entrar.
# Uso: open
# Para incluir novos caminhos, adicione-os ao array PROJETOS no arquivo .bashrc: PROJETOS+=("~/Projetos/Ettera")
open(){
    echo "Selecione um projeto para entrar:"
    local projects=()
    local project_paths=()
    local i=1

    for base_path in "${PROJETOS[@]}"; do
        base_path_resolved=$(eval echo $base_path)
        if [ -d "$base_path_resolved" ]; then
            echo ""
            echo "------ $base_path ------"
            echo ""
            for project_dir in "$base_path_resolved"/*; do
                if [ -d "$project_dir" ]; then
                    project_name=$(basename "$project_dir")
                    projects+=("$project_name")
                    project_paths+=("$project_dir")
                    echo "[$i] $project_name"
                    i=$((i + 1))
                fi
            done
        fi
    done

    if [ ${#projects[@]} -eq 0 ]; then
        echo "Nenhum projeto encontrado nos caminhos base definidos."
        return 1
    fi

    echo ""
    read -p "Escolha um número ou digite 'q' para sair: " choice
    c;

    if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le ${#projects[@]} ]; then
        local selected_index=$((choice - 1))
        local selected_path="${project_paths[$selected_index]}"
        local selected_name="${projects[$selected_index]}"

        cd "$selected_path" || { echo "Falha ao entrar no diretório."; return 1; }

        if [ -d ".git" ]; then
            git pull
        fi

        echo ""
        echo "✅ Entrada em '$selected_name' realizada com sucesso."
    elif [[ "$choice" == "q" ]]; then
        echo "⚠️ Operação cancelada."
    else
        echo "❌ Escolha inválida."
    fi
}