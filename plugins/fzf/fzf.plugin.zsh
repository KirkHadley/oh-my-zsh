# # Exit if fzf is not installed
# if ! builtin type fzf >/dev/null 2>&1; then
#   return
# fi
#
# # Setup fzf
# if [[ ! "$PATH" == */usr/local/opt/fzf/bin* ]]; then
#   export PATH="$PATH:/usr/local/opt/fzf/bin"
# fi
#
# # Man path
# if [[ ! "$MANPATH" == */usr/local/opt/fzf/man* && -d "/usr/local/opt/fzf/man" ]]; then
#   export MANPATH="$MANPATH:/usr/local/opt/fzf/man"
# fi
#
# # Auto-completion
# [[ $- == *i* ]] && source "/usr/local/opt/fzf/shell/completion.zsh" 2> /dev/null
#
# # Key bindings
# source "/usr/local/opt/fzf/shell/key-bindings.zsh"
# #
test -d "${FZF_BASE}" && fzf_base="${FZF_BASE}"

if [[ -z "${fzf_base}" ]]; then
  fzfdirs=(
    "${HOME}/.fzf"
    "/usr/local/opt/fzf"
    "/usr/share/fzf"
  )
  for dir in ${fzfdirs}; do
      if [[ -d "${dir}" ]]; then
          fzf_base="${dir}"
          break
      fi
  done

  if [[ -z "${fzf_base}" ]]; then
      if (( ${+commands[brew]} )) && dir="$(brew --prefix fzf 2>/dev/null)"; then
          if [[ -d "${dir}" ]]; then
              fzf_base="${dir}"
          fi
      fi
  fi
fi

if [[ -n "${fzf_base}" ]]; then

  # Fix fzf shell directory for Archlinux package
  if [[ ! -d "${fzf_base}/shell" ]] && [[ -f /etc/arch-release ]]; then
    fzf_shell="${fzf_base}"
  else
    fzf_shell="${fzf_base}/shell"
  fi

  # Setup fzf
  # ---------
  if ! (( ${+commands[fzf]} )) && [[ ! "$PATH" == *$fzf_base/bin* ]]; then
    export PATH="$PATH:$fzf_base/bin"
  fi

  # Auto-completion
  # ---------------
  if [[ ! "$DISABLE_FZF_AUTO_COMPLETION" == "true" ]]; then
    [[ $- == *i* ]] && source "${fzf_shell}/completion.zsh" 2> /dev/null
  fi

  # Key bindings
  # ------------
  if [[ ! "$DISABLE_FZF_KEY_BINDINGS" == "true" ]]; then
    source "${fzf_shell}/key-bindings.zsh"
  fi

else
  print "[oh-my-zsh] fzf plugin: Cannot find fzf installation directory.\n"\
        "Please add \`export FZF_BASE=/path/to/fzf/install/dir\` to your .zshrc" >&2
fi

unset fzf_base fzf_shell dir fzfdirs
