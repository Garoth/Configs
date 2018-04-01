export M2_HOME=/usr/local/apache-maven/apache-maven-3.0.3/
export MAVEN_HOME=${M2_HOME}
export MAVEN_OPTS="-Xmx512m"
export M2=$M2_HOME/bin
# the root folder for web, notestore and whatever other projects
export EVERNOTE_PROJ_ROOT=$HOME/Programs
export JAVA_HOME="/Library/Java/JavaVirtualMachines/jdk1.7.0_45.jdk/Contents/Home"
export STUDIO_JDK="/Library/Java/JavaVirtualMachines/jdk1.8.0_25.jdk"
export JAVA_OPTS="-Xms512m -Xmx1024m -XX:PermSize=512m -XX:MaxPermSize=2048m"
export MYSQL_HOME=/usr/local/mysql
export TOMCAT_HOME=/usr/local/Cellar/tomcat6/6.0.37/libexec
export CATALINA_HOME=$TOMCAT_HOME
export CATALINA_BASE=$TOMCAT_HOME
export CATALINA=$TOMCAT_HOME
# Initialization for Adobe Font Dev Kit tools
export FDK_EXE="/Users/lung/Programs/FDK/Tools/osx"

       PATH=/Users/athorp/Programs/golang/bin:$PATH
       PATH=/Users/athorp/Programs/realtime-utils:$PATH
       PATH=/Users/athorp/.scripts:${PATH}
       PATH=/usr/local/opt/coreutils/libexec/gnubin:$PATH
       PATH=/usr/local/opt/gnu-sed/libexec/gnubin:$PATH
       PATH=/opt/local/bin:${PATH}
       PATH=/usr/local/bin:${PATH}
       PATH=/usr/local/sbin:${PATH}
       PATH=${JAVA_HOME}/bin:${PATH}
       PATH=${PATH}:${M2_HOME}/bin
       PATH=${PATH}:${MYSQL_HOME}/bin
       PATH=${PATH}:${TOMCAT_HOME}/bin
       PATH=${PATH}:/usr/local/node_modules/jshint/bin
       PATH=${PATH}:${FDK_EXE}
export PATH
export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"
export EDITOR="nvim"
export CRAWL_NAME="Garoth"
export CRAWL_PIZZA="Jalapeno"
export CRAWL_DIR="$HOME/.crawl/"
export CRAWL_RC="$HOME/.crawl/crawlrc"
export ZSH_WORKDIR="$HOME/.zsh"
alias restartAudio="sudo kextunload /System/Library/Extensions/AppleHDA.kext; sudo kextload /System/Library/Extensions/AppleHDA.kext"

# Go settings
export GOPATH="$HOME/Programs/golang"
alias go-test="go test -v 2>&1 | golorize -conf=$HOME/.golorize/go-test.json"

export PROJECT_DIR="$HOME/Programs"
export MAC_PROJECT_DIR="$PROJECT_DIR/mac"
export CLOSURE_JAR_PATH="$PROJECT_DIR/common-editor/tools/closure/compiler.jar"

# Lets you read Common Editor from the filesystem directly
alias cedebugoff='defaults delete com.evernote.Evernote ENDebugLocalCommonEditorPath'
alias cedebugon='defaults write com.evernote.Evernote ENDebugLocalCommonEditorPath "$PROJECT_DIR/common-editor/"'
# Lets you use uncompiled Common Editor files
alias ceuncompiledoff='defaults delete com.evernote.Evernote ENDebugLocalCommonEditorUncompiled'
alias ceuncompiledon='defaults write com.evernote.Evernote ENDebugLocalCommonEditorUncompiled -bool true'
# Lets you use new Common Editor undo system
alias certeoff='defaults delete com.evernote.Evernote ENDebugCommonEditorRichText'
alias certeon='defaults write com.evernote.Evernote ENDebugCommonEditorRichText -bool true'
# Lets you use stage
alias enstageon='defaults write ~/Library/Preferences/com.evernote.Evernote ENSubstituteServerName stage.evernote.com'
alias enstageoff='defaults delete ~/Library/Preferences/com.evernote.Evernote ENSubstituteServerName'
# Lets you use the debug menus in webviews
# alias endevtoolson='defaults write com.evernote.Evernote ENAppsShowDevTools -bool YES'
# alias endebugmenuon='defaults write com.evernote.Evernote IncludeDebugMenu -bool YES'
# defaults write ~/Library/Preferences/com.evernote.Evernote.plist WebKitDeveloperExtras -bool true
# Have to maybe use Safari + enable debug there too...
# 1) `defaults write com.evernote.Evernote ENDebugCommonEditorRichText -bool true`
# 2) `defaults write com.evernote.Evernote ENAppsShowDevTools -bool YES`
# 3) `defaults write com.evernote.Evernote IncludeDebugMenu -bool YES`
# 4) `defaults write ~/Library/Preferences/com.evernote.Evernote.plist WebKitDeveloperExtras -bool true
# Disables updates to an externals repo
alias enupdateoff='echo off > externals_update_disabled'
alias enupdateon='rm externals_update_disabled'

# Switches between Uno and whatever was in Mac
alias use-stock='defaults delete com.evernote.Evernote ENDebugLocalCommonEditorPath'
alias use-uno='defaults write com.evernote.Evernote ENDebugLocalCommonEditorPath "$PROJECT_DIR/uno/mac-dev.html"'
alias use-uno-compiled='defaults write com.evernote.Evernote ENDebugLocalCommonEditorPath "$PROJECT_DIR/uno/build/mac.html"'
alias use-uno-server='defaults write com.evernote.Evernote ENDebugLocalCommonEditorPath "http://localhost:8888/mac-dev.html"'
alias use-uno-realtime='defaults write com.evernote.Evernote ENDebugLocalCommonEditorPath "http://104.196.226.94:443/mac-dev.html"'
alias use-rte-localhost='defaults write ~/Library/Preferences/com.evernote.Evernote.plist ENRTEServerURL http://localhost:1234'
alias use-rte-default='defaults delete ~/Library/Preferences/com.evernote.Evernote.plist ENRTEServerURL'

# Evernote Stuff
alias rte-localhost='defaults write ~/Library/Preferences/com.evernote.Evernote.plist ENRTEServerURL http://localhost:1234'
alias rte-production='defaults write ~/Library/Preferences/com.evernote.Evernote.plist ENRTEServerURL https://rte.www.evernote.com/'
alias rte-stage='defaults write ~/Library/Preferences/com.evernote.Evernote.plist ENRTEServerURL https://rte.stage.evernote.com/'
alias rte-clear='defaults delete ~/Library/Preferences/com.evernote.Evernote.plist ENRTEServerURL'
alias en-rm-mac-version-files='rm ~/Library/Application\ Support/com.evernote.Evernote/version ~/Library/Application\ Support/com.evernote.Evernote/stage.evernote.com/version'

# Evernote URLs
alias open-jenkins-npm='open "https://build-build1.c.en-testing.internal//view/NPM/"'
alias open-artifactory='open "https://maven.vpn.etonreve.com/webapp/#/artifacts/browse/simple/General/npm-local"'
alias open-realtime-test='open "localhost:8888/demo/index.html?platform=mac&room=4c5b999d-4914-490c-aabb-a1be110c7959&authToken=S=s1:U=ff415:E=15bf7303469:C=15b5cb16c69:P=5fd:A=en-web:V=2:H=c6e980499cee713941b3524be923a9c3&serviceURL=https://stage.evernote.com/shard/s1/notestore&name=Andrei"'

# Turns on uncompiled debug mode on or off, for true or false
cedebugmode() {
  if [[ "$1" == "on" ]]; then
    echo 'CE Debug                 [\e[32;1mON\e[0m]'
    cedebugon &> /dev/null
    echo 'CE Uncompiled            [\e[32;1mON\e[0m]'
    ceuncompiledon &> /dev/null
  else
    echo 'CE Debug                 [\e[31;1mOFF\e[0m]'
    cedebugoff &> /dev/null
    echo 'CE Uncompiled            [\e[31;1mOFF\e[0m]'
    ceuncompiledoff &> /dev/null
  fi

  echo 'CE RTE                   [\e[32;1mON\e[0m]'
  certeon &> /dev/null
  echo 'EN Dev Tools             [\e[32;1mON\e[0m]'
  endevtoolson &> /dev/null
  echo 'EN Debug Menu            [\e[32;1mON\e[0m]'
  endebugmenuon &> /dev/null
}

if [[ -d "$HOME/Programs/common-editor" ]]; then
    source $HOME/Programs/common-editor/source.sh
fi
