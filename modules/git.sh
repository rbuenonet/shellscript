alias gitstatus="c; git status -sb"                                             # Lista de arquivos modificados (resumido)
alias gitreset="c; git checkout -- ."                                           # Reseta todas as modificações não comitadas
alias gitlog="c; git log --all --graph --decorate --oneline --abbrev-commit"    # Histórico visual
alias gitedit="git commit --amend"                                              # Edita mensagem do último commit


# Retorna o nome da branch atual
# Exemplo:
#   git_branch
#   git_branch \( \)        # Retorna o nome da branch com prefixo e sufixo: (dev)
git_branch() {
  if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    BRANCH=$(git symbolic-ref --short HEAD 2>/dev/null || git describe --tags --exact-match 2>/dev/null)
    echo "$1$BRANCH$2"
  else
    echo ''
  fi
}

# Carrega uma branch, faz merge com outra e atualiza
# Exemplo:
#   git_load_branch              # Faz merge da branch atual com dev
#   git_load_branch minha       # Faz merge da branch "minha" com dev
#   git_load_branch minha main  # Faz merge da branch "minha" com main
git_load_branch() {
    c

    local BRANCH ORIGIN
    BRANCH=${1:-$(git_branch)}      # Define branch de destino (a que receberá o merge)
    ORIGIN=${2:-dev}                # Define a branch de origem (a que será mergeada na outra)
    
    # Verificar se as branches existem
    if ! git show-ref --verify --quiet "refs/heads/$BRANCH"; then
        echo "⚠️ A branch $BRANCH não existe!"
        return 1
    fi

    if ! git show-ref --verify --quiet "refs/heads/$ORIGIN"; then
        echo "⚠️ A branch $ORIGIN não existe!"
        return 1
    fi

    echo "------------------------- INICIO -------------------------"
    echo "------------------------- Mudando para branch $ORIGIN -------------------------"
    git checkout "$ORIGIN" || return 1      # Verifica se o checkout foi bem-sucedido

    echo "------------------------- Atualizando branch $ORIGIN -------------------------"
    git pull || return 1                    # Verifica se o pull foi bem-sucedido

    echo "------------------------- Mudando para branch $BRANCH -------------------------"
    git checkout "$BRANCH" || return 1      # Verifica se o checkout foi bem-sucedido

    echo "------------------------- Mergeando a branch $BRANCH com a $ORIGIN -------------------------"
    git merge "$ORIGIN" || return 1         # Verifica se o merge foi bem-sucedido

    echo "------------------------- FIM -------------------------"

    git_set_prompt
}

# Remove branches locais que não existem mais no remoto
git_clean_branches() {
    c
    echo "🔍 Buscando branches remotas..."
    git fetch -p  # Remove referências obsoletas

    echo "🧹 Limpando branches locais que foram removidas no remoto..."
    for branch in $(git branch -vv | grep ': gone]' | awk '{print $1}'); do
        echo "❌ Deletando branch local: $branch"
        git branch -D "$branch"
    done
}

# Faz squash dos últimos N commits
# Exemplo: git_squash 3
git_squash() {
    c
    local COUNT=${1:-2}
    echo "⚠️ Iniciando squash dos últimos $COUNT commits..."
    git rebase -i HEAD~"$COUNT"
}

# Push forçado com segurança
git_push_force() {
    c
    local branch=$(git_branch)
    echo "🚀 Realizando push forçado com segurança na branch: $branch"
    git push --force-with-lease origin "$branch"
}

# Lista as branches remotas
git_remote_branches() {
    c
    echo "🔍 Listando branches remotas..."
    git branch -r  # Exibe branches remotas
}

# Mostra o histórico de um arquivo específico
# Exemplo: git_file_history arquivo.txt
git_file_history() {
    local FILE=$1
    if [ -z "$FILE" ]; then
        echo "⚠️ Por favor, forneça o nome de um arquivo."
        return
    fi
    echo "🔍 Histórico de mudanças no arquivo: $FILE"
    git log -- "$FILE"  # Exibe o histórico de um arquivo específico
}

# Função que configura o prompt de forma inteligente
# Exemplo: git_set_prompt
git_set_prompt() {
  # Define apenas se shell for interativo
  [[ $- != *i* ]] && return

  local RESET COLOR_PATH COLOR_GIT COLOR_ERR

  RESET="\[\e[0m\]"
  COLOR_PATH="\[\e[1;34m\]"  # Azul
  COLOR_GIT="\[\e[1;33m\]"   # Amarelo
  COLOR_ERR="\[\e[1;31m\]"   # Vermelho

  if [[ -n "$ZSH_VERSION" ]]; then
    autoload -Uz colors && colors
    PROMPT='%{$fg_bold[blue]%}%~%{$reset_color%} %{$fg_bold[yellow]%}$(git_branch \( \))%{$reset_color%} %# '
    RPROMPT='%(?..%{$fg_bold[red]%}❌ %?%{$reset_color%})'
  else
    # Para Bash
    PS1="${COLOR_PATH}\W${RESET} ${COLOR_GIT}\$(git_branch \( \))${RESET} "
    # Exibe ❌ se o último comando falhou
    PROMPT_COMMAND='RET=$?; [[ $RET != 0 ]] && echo -e "\e[1;31m❌ $RET\e[0m"'
  fi
}