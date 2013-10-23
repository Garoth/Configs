export M2_HOME=/usr/local/apache-maven/apache-maven-3.0.3/
export MAVEN_HOME=${M2_HOME}
export MAVEN_OPTS="-Xmx512m"
export M2=$M2_HOME/bin
# the root folder for web, notestore and whatever other projects
export EVERNOTE_PROJ_ROOT=$HOME/Programs
export JAVA_HOME=/Library/Java/Home
export JAVA_OPTS="-Xms512m -Xmx1024m -XX:PermSize=512m -XX:MaxPermSize=2048m"
export MYSQL_HOME=/usr/local/mysql
export TOMCAT_HOME=/usr/local/Cellar/tomcat6/6.0.37/libexec
export CATALINA_HOME=$TOMCAT_HOME
export CATALINA_BASE=$TOMCAT_HOME
export CATALINA=$TOMCAT_HOME
       PATH=/Users/athorp/.scripts:${PATH}
       PATH=/usr/local/opt/coreutils/libexec/gnubin:$PATH
       PATH=/usr/local/opt/gnu-sed/libexec/gnubin:$PATH
       PATH=/opt/local/bin:${PATH}
       PATH=/usr/local/bin:${PATH}
       PATH=/usr/local/sbin:${PATH}
       PATH=${PATH}:${M2_HOME}/bin
       PATH=${PATH}:${JAVA_HOME}/bin
       PATH=${PATH}:${MYSQL_HOME}/bin
       PATH=${PATH}:${TOMCAT_HOME}/bin
export PATH
export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"
export VIMRUNTIME="/usr/local/share/vim/vim74"
export EDITOR="/usr/local/bin/vim"
export CRAWL_NAME="Garoth"
export CRAWL_PIZZA="Jalapeno"
export CRAWL_DIR="$HOME/.crawl/"
export CRAWL_RC="$HOME/.crawl/crawlrc"
export ZSH_WORKDIR="$HOME/.zsh"
export HOMEBREW_GITHUB_API_TOKEN=6b7e0277e0511a697cf32f0e0e783df3f702f3fc
export GOPATH="$HOME/Programs/golang"
export GOROOT="/usr/local/Cellar/go/1.1.2/"
