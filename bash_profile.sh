#load plugin nvm - controll npm version
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


#android configuration
export ANDROID_SDK_ROOT=$HOME/Library/Android/sdk

# avdmanager, sdkmanager
export PATH=$PATH:$ANDROID_SDK_ROOT/tools/bin

# adb, logcat
export PATH=$PATH:$ANDROID_SDK_ROOT/platform-tools

# emulator
export PATH=$PATH:$ANDROID_SDK_ROOT/emulator

#put the actual path and branch name
# export PS1="%.%\ $(git_branch \( \))$"
export PS1="\W ($(git_branch))$" #shortcuts





#diferença de arquivo
ARQUIVO='.bash_profile'
# ARQUIVO='.zshenv'

#shortcuts
alias c='for i in {1..100}; do echo -e "\n"; done; clear'
alias ll="c; ls -lah"
alias edit='open -a "Visual Studio Code"'

#alias control
# alias aliasll='cat ~/.zshenv'
# alias aliasedit='edit ~/.zshenv'
# alias aliasreload='source ~/.zshenv'
alias aliasll="cat ~/$ARQUIVO"
alias aliasedit="edit ~/$ARQUIVO"
alias aliasreload="source ~/$ARQUIVO"


#alias ionic
alias clean="rm -rf www platforms plugins;c"
alias cleanfull="clean; rm -rf node_modules .sourcemaps .vscode;c"
alias web='c;ionic serve'
alias android='c; ionic_change_icon android; ionic cordova run android; copy platforms/android/app/build/outputs/apk/debug/app-debug.apk ultima_versao/app.apk'
alias ios='ionic_change_icon ios; c; ionic cordova build ios; ios_einstein; open ./platforms/ios/AtualizacaoMedicaPersonalizada.xcworkspace'
alias certificado='cp -r  www/certificado/* ./certificado/'

#aliasgit
alias gs="c;git status -sb" #lista de arquivos modificados
alias gr="c;git reset --hard" #apaga todas as modificações não comitadas
alias gl="c;git log --all --graph --decorate --oneline --abbrev-commit" #lista de commits
alias gc="git commit --amend" #edita msg ultimo commit

#alias npm
alias npmg="npm list -g --depth=0" #lista todos os modulos instalados globalmente


#
#functions
#

#return name branch
git_branch() {
    if [ -d .git ]; then
        BRANCH=$(git branch | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')
        echo "$1$BRANCH$2"
    else
        echo ''
    fi;
}


# update branch with other branch (default update with develop)
# example: git_update_branch
# example: git_update_branch brnach_destino
# example: git_update_branch brnach_destino branch_origem
git_update_branch(){

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
#example: replace [NAME FILE] [STRING SEARCH] [NEW STRING]
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

#change file icon for platform
# require 2 files in folder ./resources with name icon-[PLATFORM].png
ionic_change_icon(){
    PLATFORM=$1
    cp -rf resources/icon-$PLATFORM.png resources/icon.png;
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
    docker run -d -p 80:8080 $CONTEINER
    
}

#stop and remove all exec conteiner's and images
docker_clean(){
    docker ps -a -q | while read line ; do echo "------------------------- Parando e excluindo conteiner $line -------------------------"; docker stop $line; docker rm $line; done
    docker images -q | while read line ; do echo "------------------------- Excluindo imagem $line -------------------------"; docker image rm $line; done
}





#alias einstein
#update archive config in project, for change project name correct
ios_einstein(){
    FILE='platforms/ios/AtualizacaoMedicaPersonalizada/AtualizacaoMedicaPersonalizada-Info.plist'
    SEARCH='AtualizacaoMedicaPersonalizada'

    replace $FILE $SEARCH Atualização\ Médica\ Personalizada
}