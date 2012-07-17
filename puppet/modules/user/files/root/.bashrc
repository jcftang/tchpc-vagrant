[ -f /etc/bashrc ] && source /etc/bashrc

PATH=/usr/local/bin:/bin:/usr/bin
PATH=$PATH:/usr/local/sbin:/sbin:/usr/sbin
export PATH

export HISTCONTROL=ignoredups
export LESSHISTFILE=-
export LESS=-CRSi

alias ..="cd .."
alias ll="ls -la"
alias man="LANG=C man"
alias asme='KRB5CCNAME="$OLDKRB5CCNAME"'
alias swhois="asme /usr/local/bin/whois"

function orig ()     { for f in "$@"; do cp -pr "$f"{,.orig};   done }
function difforig () { for f in "$@"; do diff -ur "$f"{.orig,}; done }

known_hosts=$(egrep -shv '^(#|$)' /etc/ssh/ssh_known_hosts | cut -d, -f1)
complete -W "$known_hosts" -o default ssh
complete -W "$known_hosts" -S : -o default scp
unset known_hosts

function _service() {
  if [ $COMP_CWORD -eq 1 ]; then
    COMPREPLY=( $(compgen -W "$(for i in /etc/init.d/*; do echo ${i##*/}; done)" -- $2) )
  elif [ $COMP_CWORD -eq 2 ]; then
    COMPREPLY=( $(compgen -W "$(sed -ne "y/|/ /;s/^.*Usage.*{\(.*\)}.*$/\1/p" /etc/init.d/"$3" 2>/dev/null)" -- $2) )
  fi
}

complete -F _service service

function _yum() {
  local flags='--help --version --showduplicates --installroot --enablerepo \
    --disablerepo --obsoletes --disableplugin --noplugins --nogpgcheck \
    --skip-broken'

  local commands='install update check-update upgrade remove erase list info \
    provides whatprovides clean makecache groupinstall groupupdate grouplist \
    groupremove groupinfo search shell resolvedep localinstall localupdate \
    reinstall downgrade deplist repolist help'

  case "$3" in
    -c|localinstall|localupdate)
      COMPREPLY=( $( compgen -f -- "$2" ) )
      ;;
    --installroot)
      COMPREPLY=( $( compgen -d -- "$2" ) )
      ;;
    list)
      COMPREPLY=( $( compgen -W 'all available updates installed extras obsoletes recent' -- "$2" ) )
      ;;
    clean)
      COMPREPLY=( $( compgen -W 'expire-cache packages headers metadata dbcache all' -- "$2" ) )
      ;;
    help)
      COMPREPLY=( $( compgen -W "$commands" -- "$2") )
      ;;
    *)
      COMPREPLY=( $( compgen -W "$flags $commands" -- "$2") )
      ;;
  esac
}

complete -F _yum -o default yum

if [ -r /etc/bash_completion.d/git ]; then
  source /etc/bash_completion.d/git
  PS1='[\u@\h \W$(__git_ps1 " (%s)")]\$ '
fi

function pepuppet() {
  environment=$(sed -ne '/^ *environment *= */s///p' /etc/puppet/puppet.conf)
  FACTER_preserve_environment=$environment puppet "$@"
}

[ -f ~/.bashrc.local ] && source ~/.bashrc.local
