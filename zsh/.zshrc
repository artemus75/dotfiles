# Kubectl Functions
# ---
#
alias k="kubectl"
alias h="helm"

kn() {
    if [ "$1" != "" ]; then
            kubectl config set-context --current --namespace=$1
    else
            echo -e "\e[1;31m Error, please provide a valid Namespace\e[0m"
    fi
}

knd() {
    kubectl config set-context --current --namespace=default
}

ku() {
    kubectl config unset current-context
}

# Colormap
function colormap() {
  for i in {0..255}; do print -Pn "%K{$i}  %k%F{$i}${(l:3::0:)i}%f " ${${(M)$((i%6)):#3}:+$'\n'}; done
}

# ALIAS COMMANDS
alias ls="exa --icons --group-directories-first"
alias ll="exa --icons --group-directories-first -al"
alias g="goto"
alias grep='grep --color'
alias docker=podman

# exa
[[ ! -f /usr/bin/exa ]] && echo "Warning: exa is not installed" || alias ls="exa --icons --group-directories-first"

# find out which distribution we are running on
LFILE="/etc/*-release"
MFILE="/System/Library/CoreServices/SystemVersion.plist"
if [[ -f $LFILE ]]; then
  _distro=$(awk '/^ID=/' /etc/*-release | awk -F'=' '{ print tolower($2) }')
elif [[ -f $MFILE ]]; then
  _distro="macos"
fi

# set an icon based on the distro
# make sure your font is compatible with https://github.com/lukas-w/font-logos
case $_distro in
    *kali*)                  ICON="ﴣ";;
    *arch*)                  ICON="";;
    *debian*)                ICON="";;
    *raspbian*)              ICON="";;
    *ubuntu*)                ICON="";;
    *elementary*)            ICON="";;
    *fedora*)                ICON="";;
    *coreos*)                ICON="";;
    *gentoo*)                ICON="";;
    *mageia*)                ICON="";;
    *centos*)                ICON="";;
    *opensuse*|*tumbleweed*) ICON="";;
    *sabayon*)               ICON="";;
    *slackware*)             ICON="";;
    *linuxmint*)             ICON="";;
    *alpine*)                ICON="";;
    *aosc*)                  ICON="";;
    *nixos*)                 ICON="";;
    *devuan*)                ICON="";;
    *manjaro*)               ICON="";;
    *rhel*)                  ICON="";;
    *macos*)                 ICON="";;
    *)                       ICON="";;
esac

export STARSHIP_DISTRO="$ICON"

# Load Starship
eval "$(starship init zsh)"

# get zsh complete kubectl
source <(kubectl completion zsh)
alias kubectl=kubecolor
# make completion work with kubecolor
compdef kubecolor=kubectl

export KUBECONFIG=~/.kube/clusters/config

clear
neofetch

#export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
export PATH=$PATH:$JAVA_HOME/bin
export PATH="${PATH}:~/.local/bin"
export HISTFILE=~/.zsh_history
export HISTSIZE=1000
export SAVEHIST=1000
export SOPS_AGE_KEY_FILE=$HOME/.sops/key.txt
export EDITOR=nano # Replace by your favorite editor
export JQ_COLORS="1;90:0;35:0;35:0;91:0;33:1;37:1;37"
# add Pulumi to the PATH
#export PATH=$PATH:$HOME/.pulumi/bin

#export ANSIBLE_CONFIG=/home/michael/projects/ansible/ansible.cfg

# key bindings
bindkey "\e[1~" beginning-of-line
bindkey "\e[4~" end-of-line
bindkey "\e[5~" beginning-of-history
bindkey "\e[6~" end-of-history
bindkey "\e[3~" delete-char
bindkey "\e[2~" quoted-insert
bindkey "\e[5C" forward-word
bindkey "\eOc" emacs-forward-word
bindkey "\e[5D" backward-word
bindkey "\eOd" emacs-backward-word
bindkey "\ee[C" forward-word
bindkey "\ee[D" backward-word
bindkey "\^H" backward-delete-word
# for rxvt
bindkey "\e[8~" end-of-line
bindkey "\e[7~" beginning-of-line
# for non RH/Debian xterm, can't hurt for RH/DEbian xterm
bindkey "\eOH" beginning-of-line
bindkey "\eOF" end-of-line
# for freebsd console
bindkey "\e[H" beginning-of-line
bindkey "\e[F" end-of-line
# completion in the middle of a line
bindkey '\^i' expand-or-complete-prefix
eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >> ~/.zshrc