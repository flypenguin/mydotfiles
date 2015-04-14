#SingleInstance force

PasteAliases =
( % `
export LS_COLORS='no=00:fi=00:di=36:ln=35:pi=30;44:so=35;44:do=35;44:bd=33;44:cd=37;44:or=05;37;41:mi=05;37;41:ex=01;31:*.cmd=01;31:*.exe=01;31:*.com=01;31:*.bat=01;31:*.reg=01;31:*.app=01;31:*.txt=32:*.org=32:*.md=32:*.mkd=32:*.h=32:*.c=32:*.C=32:*.cc=32:*.cpp=32:*.cxx=32:*.objc=32:*.sh=32:*.csh=32:*.zsh=32:*.el=32:*.vim=32:*.java=32:*.pl=32:*.pm=32:*.py=32:*.rb=32:*.hs=32:*.php=32:*.htm=32:*.html=32:*.shtml=32:*.xml=32:*.rdf=32:*.css=32:*.js=32:*.man=32:*.0=32:*.1=32:*.2=32:*.3=32:*.4=32:*.5=32:*.6=32:*.7=32:*.8=32:*.9=32:*.l=32:*.n=32:*.p=32:*.pod=32:*.tex=32:*.bmp=33:*.cgm=33:*.dl=33:*.dvi=33:*.emf=33:*.eps=33:*.gif=33:*.jpeg=33:*.jpg=33:*.JPG=33:*.mng=33:*.pbm=33:*.pcx=33:*.pdf=33:*.pgm=33:*.png=33:*.ppm=33:*.pps=33:*.ppsx=33:*.ps=33:*.svg=33:*.svgz=33:*.tga=33:*.tif=33:*.tiff=33:*.xbm=33:*.xcf=33:*.xpm=33:*.xwd=33:*.xwd=33:*.yuv=33:*.aac=33:*.au=33:*.flac=33:*.mid=33:*.midi=33:*.mka=33:*.mp3=33:*.mpa=33:*.mpeg=33:*.mpg=33:*.ogg=33:*.ra=33:*.wav=33:*.anx=33:*.asf=33:*.avi=33:*.axv=33:*.flc=33:*.fli=33:*.flv=33:*.gl=33:*.m2v=33:*.m4v=33:*.mkv=33:*.mov=33:*.mp4=33:*.mp4v=33:*.mpeg=33:*.mpg=33:*.nuv=33:*.ogm=33:*.ogv=33:*.ogx=33:*.qt=33:*.rm=33:*.rmvb=33:*.swf=33:*.vob=33:*.wmv=33:*.doc=31:*.docx=31:*.rtf=31:*.dot=31:*.dotx=31:*.xls=31:*.xlsx=31:*.ppt=31:*.pptx=31:*.fla=31:*.psd=31:*.7z=1;35:*.apk=1;35:*.arj=1;35:*.bin=1;35:*.bz=1;35:*.bz2=1;35:*.cab=1;35:*.deb=1;35:*.dmg=1;35:*.gem=1;35:*.gz=1;35:*.iso=1;35:*.jar=1;35:*.msi=1;35:*.rar=1;35:*.rpm=1;35:*.tar=1;35:*.tbz=1;35:*.tbz2=1;35:*.tgz=1;35:*.tx=1;35:*.war=1;35:*.xpi=1;35:*.xz=1;35:*.z=1;35:*.Z=1;35:*.zip=1;35:*.ANSI-30-black=30:*.ANSI-01;30-brblack=01;30:*.ANSI-31-red=31:*.ANSI-01;31-brred=01;31:*.ANSI-32-green=32:*.ANSI-01;32-brgreen=01;32:*.ANSI-33-yellow=33:*.ANSI-01;33-bryellow=01;33:*.ANSI-34-blue=34:*.ANSI-01;34-brblue=01;34:*.ANSI-35-magenta=35:*.ANSI-01;35-brmagenta=01;35:*.ANSI-36-cyan=36:*.ANSI-01;36-brcyan=01;36:*.ANSI-37-white=37:*.ANSI-01;37-brwhite=01;37:*.log=01;34:*~=01;34:*#=01;34:*.bak=01;36:*.BAK=01;36:*.old=01;36:*.OLD=01;36:*.org_archive=01;36:*.off=01;36:*.OFF=01;36:*.dist=01;36:*.DIST=01;36:*.orig=01;36:*.ORIG=01;36:*.swp=01;36:*.swo=01;36:*,v=01;36:*.gpg=34:*.gpg=34:*.pgp=34:*.asc=34:*.3des=34:*.aes=34:*.enc=34:' ;\
export LESS='-ImqSw#20' ;\
alias gco="git checkout" ;\
alias gri="git rebase --interactive" ;\
alias gra="git rebase --abort" ;\
alias grc="git rebase --continue" ;\
alias gpf="git push --force" ;\
alias  gp="git push" ;\
alias  gs="git status" ;\
alias  gd="git diff" ;\
alias gdc="git diff --cached" ;\
alias gls="git log --pretty=format:'%C(yellow)%h%Cred%d %Creset%s%Cblue [%cn]' --decorate" ;\
alias gll="git log --pretty=format:'%C(yellow)%h%Cred%d %Creset%s%Cblue [%cn]' --decorate --numstat" ;\
alias gld="git log --pretty=format:'%C(yellow)%h %ad%Cred%d %Creset%s%Cblue [%cn]' --decorate --date=short" ;\
alias glr="git log --pretty=format:'%C(yellow)%h %ad%Cred%d %Creset%s%Cblue [%cn]' --decorate --date=relative" ;\
alias ls="ls --color=auto" ;\
alias dir="ls -lh" ;\
alias tma="tmux attach" ;\
alias tml="tmux list-sessions" ;\
alias    pat="puppet agent --test" ;\
alias   patn="puppet agent --test --noop" ;\
alias   tpat="time puppet agent --test" ;\
alias  tpatn="time puppet agent --test --noop" ;\
alias   cpat="clear ; puppet agent --test" ;\
alias  cpatn="clear ; puppet agent --test --noop" ;\
alias  ctpat="clear ; time puppet agent --test" ;\
alias ctpatn="clear ; time puppet agent --test --noop" ;\
alias ccat="fleshcat" ;\
alias ssr="ssh -l root" ;\
alias ssn='ssh -o "UserKnownHostsFile /dev/null" -o "StrictHostKeyChecking no" -i /usr/share/buildlab/key_rsa' ;\
alias duhere="du . --max-depth=1 -h" ;\
alias stamp="date +%Y-%m-%d__%H.%M.%S" ;\
alias yumvars="python -c 'import yum, pprint; yb = yum.YumBase(); pprint.pprint(yb.conf.yumvar, width=1)'" ;\
alias pssh="ssh -o PasswordAuthentication=yes -o PubkeyAuthentication=no" ;\
alias datestamp="python -c \"import datetime ; import sys; print(datetime.datetime.fromtimestamp(int(sys.argv[1])).strftime('%Y-%m-%d %H:%M:%S'))\"" ;\
alias yi="yum install" ;\
alias ys="yum search" ;\
alias wire="nohup wireshark > /dev/null 2>&1 &" ;\
alias xv="x509l" ;\
alias wireinst="yum install wireshark-gnome xorg-x11-xauth xorg-x11-fonts\* dejavu\* liberation\*" ;\
save() { cp "$1" "${1}__$(stamp)" ; } ;\
sshkill() { kill -9 `ps aux | grep ssh | grep -v grep | grep $1 | awk '{print $2}' ` ; } ;\
x509() { one="$1" ; shift ; openssl x509 -in "$one" -noout -text $@ ; } ;\
x509l() { one="$1" ; shift ; openssl x509 -in "$one" -noout -text $@ | less; } ;\
crl() { one="$1" ; shift ; openssl crl -in "$one" -noout -text $@ ; } ;\
crll() { one="$1" ; shift ; openssl crl -in "$one" -noout -text $@ | less ; } ;\
sshrem() { T=`mktemp`;U=~/.ssh/known_hosts;cat $U|grep -vE "^${1//./\\.}">$T;cat $T>$U;rm -rf $T; } ;\
fleshcat() { if [ "$2" == "" ]; then C="#" ; else C="$2" ; fi ; grep -Ev "^ *($C.*)?$" "$1" ; } ;\
wipedev() { if [ "$1" == "" ]; then echo -e "\nUSAGE: wipedev <device_without_/dev>\n" ; else echo -e "\nREALLY wipe '/dev/$1' (y/n)?" ; read yn ; if [ "$yn" == "y" ] ; then if [ ! -b /dev/$1 ]; then echo -e "ERROR: /dev/$1 not found or not a device.\n" ; else echo "Wiping /dev/$1" ; dd if=/dev/zero of=/dev/$1 bs=1M count=25; echo -e "done.\n" ; fi ; else echo -e "Abort.\n" ; fi ; fi }

)


::-abm::
  Send, axel.bock.mail@gmail.com
  Return

::-mab::
  Send, mr.axel.bock@gmail.com
  Return

::-ssb::
  Send, sihtsielbasopsid@gmail.com
  Return

::.ab::
  Send, axel.bock
  Return

::-aba::
  Send, axel.bock@amadeus.com
  Return

::..al::
  clipboard = %PasteAliases%
  SendInput ^v
  Return

::..moba::
  clipboard = %PasteAliases%
  Return

