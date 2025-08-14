# ------------------------------------------------------------------
# Arquivo de aliases personalizados para terminal
# ------------------------------------------------------------------

ARQUIVO='.bashrc' #name default file
PATHPROJECT="$HOME/Projetos/_lab/shellscript"

alias c='command -v c >/dev/null; for i in {1..100}; do echo -e "\n"; done; clear' # Limpa o terminal imprimindo várias linhas antes do clear
alias ll='c; ls -GFlah' # Lista detalhada com cores e limpa antes
alias update='sudo apt update && sudo apt upgrade -y' # Alias de atualização de pacotes


alias aliasedit="code $PATHPROJECT ~/$ARQUIVO"
alias aliasreload="c; source ~/$ARQUIVO"

alias ..='cd ..' # Alias para voltar um diretório
alias ...='cd ../..' # Alias para voltar dois diretórios
alias ....='cd ../../..' # Alias para voltar três diretórios

