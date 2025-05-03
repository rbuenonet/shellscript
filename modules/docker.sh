# ------------------------------------------------------------------
# Arquivo de alias e funções personalizadas para docker
# ------------------------------------------------------------------

# Docker aliases
alias dockerps='c; docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"'    # Lista os containers em execução de forma formatada
alias dockerclean='c; docker system prune -f'                                          # Limpa volumes, containers e redes não utilizados
alias dockerstopall='c; docker stop $(docker ps -q)'                                  # Para todos os containers em execução
alias dockerll="c; docker ps -a"                                                      # Lista todos os containers (rodando e parados)
alias dockerrun="c; docker-compose up -d"                                             # Executa docker-compose em segundo plano
alias dockerimages="c; docker images"                                                 # Lista as imagens

# Construir uma imagem Docker
# Uso: docker_build <nome-da-imagem> [diretório]
docker_build() {
    c;

    # Verifica se o nome da imagem foi fornecido
    if [ -z "$1" ]; then
        echo "❌ Nome da imagem não informado. Uso: docker_build <nome-da-imagem>"
        return 1
    fi

    # Define o diretório de contexto. Se não for fornecido, usa o diretório atual (.).
    context=${2:-.}

    # Verifica se o diretório especificado existe
    if [ ! -d "$context" ]; then
        echo "❌ O diretório '$context' não existe."
        return 1
    fi

    # Construa a imagem Docker com o nome especificado e o diretório de contexto
    docker build -t "$1" "$context"
    echo "✔️ Imagem '$1' construída com sucesso a partir do diretório '$context'."
}

# Verifica se o Docker está rodando
# Uso: check_docker
check_docker() {
    c;
    
  if ! docker info &> /dev/null; then
    echo "⚠️  Docker não está rodando!"
    return 1
  fi
}

# Para e remove todos os containers
# Uso: docker_clean [opcional: 1 para remover imagens]
docker_clean() {
    c;
    
    # Verifica se há containers para parar/remover
    if [ -z "$(docker ps -a -q)" ]; then
        echo "❌ Nenhum container para parar ou remover."
        return 1
    fi

    # Para e remove todos os containers
    docker ps -a -q | xargs -r -n 1 -I {} bash -c '
        echo "------------------------- Parando e excluindo container {} -------------------------"
        docker stop {}
        docker rm {}
    '
    echo "✔️ Todos os containers foram parados e removidos."

    # Verifica se o parâmetro '1' foi passado para remover as imagens também
    if [[ $1 == *"1"* ]]; then
        # Verifica se há imagens para remover
        if [ -z "$(docker images -q)" ]; then
            echo "❌ Nenhuma imagem para remover."
            return 1
        fi
        
        # Remove todas as imagens
        docker images -q | xargs -r -n 1 -I {} bash -c '
            echo "------------------------- Excluindo imagem {} -------------------------"
            docker rmi {}
        '
        echo "✔️ Todas as imagens foram removidas."
    fi
}

# Entrar em um container via bash
# Uso: docker_open <nome-do-container>
docker_open() {
    c;
    
    if [ -z "$1" ]; then
        echo "❌ Container não informado. Uso: docker_open <nome>"
        return 1
    fi

    # Verifica se o container existe
    if ! docker ps -a --format '{{.Names}}' | grep -wq "$1"; then
        echo "❌ Container \"$1\" não encontrado."
        return 1
    fi

    # Tenta entrar no container com bash, se não encontrar, usa sh
    if docker exec -it "$1" bash &>/dev/null; then
        docker exec -it "$1" bash
    else
        docker exec -it "$1" /bin/sh
    fi
}

# Para, remove ou entra em um container, ou remove uma imagem, dependendo do que for encontrado
# Uso: docker_manage <nome-do-container-ou-imagem>
docker_manage() {
    c;
    
    # Verifica se o nome do container ou imagem foi fornecido
    if [ -z "$1" ]; then
        echo "❌ Nome do container ou imagem não informado. Uso: docker_manage <nome>"
        return 1
    fi
    
    # Verifica se o container existe
    container_exists=$(docker ps -a --filter "name=$1" -q)
    
    if [ -n "$container_exists" ]; then
        # Se o container existir, oferece opções para parar, remover ou entrar
        echo "✔️ Container '$1' encontrado."
        echo "O que você gostaria de fazer?"
        echo "1. Parar container"
        echo "2. Remover container"
        echo "3. Entrar no container"
        read -p "Escolha uma opção (1/2/3): " option
        case $option in
            1)
                docker stop "$1" && echo "✔️ Container '$1' parado."
                ;;
            2)
                docker rm "$1" && echo "✔️ Container '$1' removido."
                ;;
            3)
                docker_open "$1" && echo "✔️ Entrando no container '$1'." 
                ;;
            *)
                echo "❌ Opção inválida!"
                ;;
        esac
    else
        # Se o container não existir, verifica se a imagem existe
        image_exists=$(docker images --filter "reference=$1" -q)
        
        if [ -n "$image_exists" ]; then
            # Se a imagem existir, oferece a opção de removê-la
            echo "✔️ Imagem '$1' encontrada."
            echo "Deseja remover a imagem?"
            read -p "Escolha uma opção (y/n): " option
            case $option in
                y|Y)
                    docker image rm "$1" && echo "✔️ Imagem '$1' removida."
                    ;;
                n|N)
                    echo "❌ Imagem '$1' não removida."
                    ;;
                *)
                    echo "❌ Opção inválida!"
                    ;;
            esac
        else
            # Se nem o container nem a imagem existirem
            echo "❌ Nenhum container ou imagem encontrado com o nome '$1'."
        fi
    fi
}
