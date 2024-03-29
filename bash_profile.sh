# for load this arquive, only open the file .zshenv or .bash_sprofile and copy/paste 
# next 2 command
#ARQUIVE='/mnt/d/Projetos/_meu/shellscript/bash_profile.sh';
#source $ARQUIVE;

# next modified next line with name file
ARQUIVO='.zshrc' #name default file
# ARQUIVO='.bash_sprofile' #name default file


identify_terminal_version(){
    if [ -n "$ZSH_VERSION" ]; then
        echo "------------------------- zsh -------------------------"
    elif [ -n "$BASH_VERSION" ]; then
        echo "------------------------- bash -------------------------"
    else
        echo "------------------------- else -------------------------"
    fi
}


# ------------------------------ nvm configuration ------------------------------
#load plugin nvm - controll npm version
#export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
#[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
#[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


# ------------------------------ android configuration ------------------------------
# export ANDROID_SDK_ROOT=$HOME/Library/Android/sdk
# export JAVA_HOME=$(/usr/libexec/java_home -v 1.8.0_271)
# avdmanager, sdkmanager
# export PATH=$PATH:$ANDROID_SDK_ROOT/tools/bin
# adb, logcat
# export PATH=$PATH:$ANDROID_SDK_ROOT/platform-tools
# emulator
# export PATH=$PATH:$ANDROID_SDK_ROOT/emulator
# flutter
# export PATH=$PATH:$HOME/Library/Flutter/bin

#put the actual path and branch name (for mac)
# if [[ $ARQUIVO == *"zshenv"* ]]; then
#     export PS1="%.%\ $(git_branch \( \))$"
# else
#     export PS1="\W ($(git_branch))$"
# fi;


#shortcuts
alias c='for i in {1..100}; do echo -e "\n"; done; clear'
alias ll='c; ls -GFlah'
alias edit='open -a "Visual Studio Code"'

#alias control
alias aliasll="cat ~/$ARQUIVO $ARQUIVE"
alias aliasedit="edit ~/$ARQUIVO $ARQUIVE"
alias aliasreload="c; source ~/$ARQUIVO"

#aliasgit
alias gs="c;git status -sb" #lista de arquivos modificados
alias gr="c;git reset --hard" #apaga todas as modificações não comitadas
alias gl="c;git log --all --graph --decorate --oneline --abbrev-commit" #lista de commits
alias gc="git commit --amend" #edita msg ultimo commit

#alias npm
alias npmg="npm list -g --depth=0" #lista todos os modulos instalados globalmente

#alias mac
alias ioslist="xcrun simctl list"
alias nvm18="nvm use v18.19.0"

alias csv="curl -H 'Authorization: Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6Ik8zWUgxWDNjaUNMWlNvM0tUQTFpQiJ9.eyJuaWNrbmFtZSI6InJlbmF0by5idWVubyIsIm5hbWUiOiJyZW5hdG8uYnVlbm9Ac2VlZHouYWciLCJwaWN0dXJlIjoiaHR0cHM6Ly9zLmdyYXZhdGFyLmNvbS9hdmF0YXIvODYxMzZjYzY0OWM3MWY5OTczMGUyYmEyNWM1NjNmNGE_cz00ODAmcj1wZyZkPWh0dHBzJTNBJTJGJTJGY2RuLmF1dGgwLmNvbSUyRmF2YXRhcnMlMkZyZS5wbmciLCJ1cGRhdGVkX2F0IjoiMjAyNC0wMS0xN1QxOTo0NDozOC4zMzFaIiwiZW1haWwiOiJyZW5hdG8uYnVlbm9Ac2VlZHouYWciLCJlbWFpbF92ZXJpZmllZCI6ZmFsc2UsImlzcyI6Imh0dHBzOi8vbGFydXMtZGV2ZWxvcC51cy5hdXRoMC5jb20vIiwiYXVkIjoiM0NoVXZjNHhsSzIwSkhVcVc4bU9QVFhNVHZzaXhONWEiLCJpYXQiOjE3MDU1MjA2NzksImV4cCI6MTcwNTU1NjY3OSwic3ViIjoiYXV0aDB8NjU0MTQ1ZTgzY2UyMjc5NjE0YWJmY2FlIiwic2lkIjoiQ29hMERVaThnR3NEcTl1X2EtV3JkaV9ZeURxUnlrLXMifQ.jSlPmMkIzZEMgDbBJ3QHzjnejO2UwUGYkgwPvoQI4EQnVKqY1i0gasFWqjyyLX_t32DnhdcfK7MNHaswDs-X-_AympFw1Jc4665pa-LmW_95fw314lsvdLY8v9xhqhfgTAoum3oOqdEM3EOF38kUGJXp8-pTQc62-8mZNJJNnpc8TrmZ6aU4BWoaBcumjULHlNFRiLBEHIYOyhv4x9M-bucSeFlI1gwhQX9L2JnMjutYg2_yjJUNvn2vvBbHK-jc2zLB5VUPfO9AClmrZVmCGQeT4OLzgSZQfl0BA_nE8hCgKqTpKG_W3Y9a7BTG9Xgk5u-hsGBrShdZLsFRyTN-Ew' --location 'http://localhost:3000/research-form-answer/export/data?file-extension=csv' \ > teste.csv"

#
#functions
#

#remove files in all folders
superrm() {
    if [ ! -z $1 ] 
    then
        FILE = $1
        find .  -name $FILE | while read line ; do 
            echo "------------------------- Removendo arquivo: $line -------------------------"; 
            rm $line
        done
    else
        echo "Error: necessario nome do arquivo por parametro";
    fi
    
}

#return name branch
git_branch() {
    if [ -d .git ]; then
        BRANCH=$(git branch | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')
        echo "$1$BRANCH$2"
    else
        echo ''
    fi;
}


# example: git_load_branch
# example: git_load_branch branch_destino
# example: git_load_branch branch_destino branch_origem
git_load_branch(){

    if [ ! -z $1 ] 
    then
        BRANCH=$1
    else
        BRANCH=$(git_branch)
    fi

    if [ ! -z $2 ] 
    then
        ORIGIN=$2
    else
        ORIGIN="develop"
    fi    

    c;
    echo "------------------------- INICIO -------------------------"
    echo "------------------------- Mudando para branch $ORIGIN -------------------------"
    git checkout $ORIGIN;
    echo "------------------------- Atualizando branch $ORIGIN -------------------------"
    git pull;
    echo "------------------------- Mudando para branch $BRANCH -------------------------"
    git checkout $BRANCH;
    echo "------------------------- Mergeando a branch $BRANCH com a $ORIGIN -------------------------"
    git merge $ORIGIN
    echo "------------------------- FIM -------------------------"

    aliasreload
}

#reset all modificad files
git_reset(){
    git status -s | while read line ; do 
        ARCHIVE="$(cut -d' ' -f2 <<<"$line")"
        echo "------------------------- Removendo arquivo: $ARCHIVE -------------------------"; 
        git checkout -- $ARCHIVE
    done
}

# equals command CP, even if it doesn't exist folder destiny
copy(){
    ORIGIN=$1
    DESTINY=$2

    if [ ! -d `dirname $DESTINY` ] 
    then
        echo 'entrou'
        mkdir -p `dirname $DESTINY`
    fi

    cp $ORIGIN $DESTINY

    echo -e "\n---------------------------------------------------------------------------"
    echo "Arquivo: $ORIGIN"
    echo "Copiado para: $DESTINY"
    echo -e "---------------------------------------------------------------------------\n"
}

#update string in file
#command: replace [NAME FILE] [STRING SEARCH] [NEW STRING]
#example: replace the string 'world' for 'bash' in the file file_example.txt
#     FILE='file_example.txt'
#     SEARCH='world'
#     replace $FILE $SEARCH bash
replace(){
    FILE=$1
    SEARCH=$2
    OBJECT=$3

    sed -i "" "s/$SEARCH/$OBJECT/g" $FILE

    echo -e "\n---------------------------------------------------------------------------"
    echo "Arquivo: $FILE"
    echo "Trocado: $SEARCH"
    echo "Para: $OBJECT"
    echo -e "---------------------------------------------------------------------------\n"
}

#load dockerfile
#example create conteiner with name default 'my-content': docker_load 
#example create conteiner with  name 'front: docker_load front
docker_load(){
    
    if [ ! -z $1 ] 
    then
        CONTEINER=$1
    else
        CONTEINER='my-content'
    fi

    Docker build -t $CONTEINER .
    docker run -v /Users/renato/Projetos/hiae/HIAE.AMP.Front:/usr/share/nginx/html -d -p 80:8080 $CONTEINER

    #-v = tudo que tiver na pasta host (primeiro caminho) vai ser espelhado dentro do container (segundo caminho)
    
}

# stop and remove all exec conteiner's 
# if remove images too, use "1" as parameter
docker_clean(){
    docker ps -a -q | while read line ; do 
        echo "------------------------- Parando e excluindo conteiner $line -------------------------"; 
        docker stop $line; 
        docker rm $line; 
    done
    if [[ $1 == *"1"* ]]; then
        docker images -q | while read line ; do 
            echo "------------------------- Excluindo imagem $line -------------------------"; 
            docker image rm $line; 
        done
    fi
}

#update exec function after sleep time
#example: timeout [TIME SEGUNDS] [COMMAND]
# timeout 2 echo 'pam'
function timeout() { 
    vazio=''
    
    time=$1
    command=$(echo $@ | sed "s/$time //")

    sleep $time
    eval $command
}







teste(){
    echo 'function for tests'
}
