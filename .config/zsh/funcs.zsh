cdPrevDir() { 
  popd &>/dev/null
  zle reset-prompt
  echo -e "\n\e[30m$(pwd)\e[0m"
  zle reset-prompt
}
zle -N cdPrevDir

cdParentDir() {
  pushd .. &>/dev/null
  zle reset-prompt
  echo -e "\n\e[30m$(pwd)\e[0m"
  zle reset-prompt
}
zle -N cdParentDir
sudo-inject() {
  zle beginning-of-line
  zle -U "sudo "
}
zle -N sudo-inject

