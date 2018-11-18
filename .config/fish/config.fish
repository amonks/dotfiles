fish_vi_key_bindings

if type -f direnv
  eval (direnv hook fish)
end

set -x EDITOR "vim"
set -gx PATH $PATH (yarn global bin)

alias git hub
alias vim nvim
alias dotfiles 'git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
