# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=10000
setopt appendhistory extendedglob
unsetopt autocd beep nomatch notify
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/benxu/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

autoload -Uz promptinit
promptinit

# key bindings
typeset -g -A key

key[Home]="`tput khome`"
key[End]="`tput kend`"
key[Insert]="`tput kich1`"
key[Backspace]="`tput kbs`"
key[Delete]="`tput kdch1`"
key[Up]="`tput cuu1`"
key[Down]="`tput cud1`"
key[Left]="`tput cub1`"
key[Right]="`tput cuf1`"
key[PageUp]="`tput kpp`"
key[PageDown]="`tput knp`"

# key binding escape char fixes
if [[ "$TERM" == "xterm-256color" ]]; then
    key[Home]="\e[H"
    key[End]="\e[F"
fi

[[ -n "$key[Home]" ]] && bindkey -- "$key[Home]" beginning-of-line
[[ -n "$key[End]" ]] && bindkey -- "$key[End]" end-of-line
[[ -n "$key[Insert]" ]] && bindkey -- "$key[Insert]" overwrite-mode
[[ -n "$key[Backspace]" ]] && bindkey -- "$key[Backspace]" backward-delete-char
[[ -n "$key[Delete]" ]] && bindkey -- "$key[Delete]" delete-char
[[ -n "$key[Up]" ]] && bindkey -- "$key[Up]" up-line-or-history
[[ -n "$key[Down]" ]] && bindkey -- "$key[Down]" down-line-or-history
[[ -n "$key[Left]" ]] && bindkey -- "$key[Left]" backward-char
[[ -n "$key[Right]" ]] && bindkey -- "$key[Right]" forward-char

if (( ${+terminfo[smkx]} )) && (( ${+terminfo[fmkx]} )); then
	function zle-line-init () {
		echoti smkx
	}
	function zle-line-finish () {
		echoti rmkx
	}
	zle -N zle-line-init
	zle -N zle-line-finish
fi

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

if [[ $TERM != "linux" ]]; then
    powerline-daemon -q
    . /usr/lib/python3.7/site-packages/powerline/bindings/zsh/powerline.zsh
else
    PROMPT="hardyharharyernotinaguiharhar >"
fi

alias config="git --git-dir=$HOME/.cfg --work-tree=$HOME"
