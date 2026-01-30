;; Guix package manifest
;; Install with: guix package --manifest=~/.config/guix/manifest.scm

(specifications->manifest
  '(;; Shells & Terminal
    "zsh"
    "zsh-syntax-highlighting"
    "tmux"
    "starship"
    "alacritty"

    ;; Editors
    "neovim"
    "vim"
    "emacs"

    ;; Version Control
    "git"
    "git-lfs"

    ;; Search & Navigation
    "fd"
    "ripgrep"
    "fzf"
    "the-silver-searcher"
    "zoxide"
    "tree"

    ;; Programming Languages
    "clojure"
    ;; "babashka"  ; not in guix, install via: bash < <(curl -s https://raw.githubusercontent.com/babashka/babashka/master/install)
    "erlang"
    "elixir"
    "go"
    "node"
    ;; "deno"  ; not in guix
    "ocaml"
    "opam"
    "guile"
    "python"
    "ruby"

    ;; Build Tools
    "cmake"
    "ninja"
    "autoconf"
    "automake"
    "gcc-toolchain"
    "make"

    ;; CLI Utilities
    "curl"
    "wget"
    "htop"
    "jq"
    "difftastic"
    "direnv"
    "stow"
    "gnupg"
    "unzip"
    "dos2unix"
    "tldr"
    "httpie"
    "mosh"
    "socat"
    "rlwrap"

    ;; Media
    "imagemagick"
    "ffmpeg"
    "yt-dlp"

    ;; Databases
    "postgresql"
    "redis"
    "sqlite"

    ;; Documentation
    ;; "hugo"  ; not in guix
    "graphviz"

    ;; GNU Coreutils
    "coreutils"
    "findutils"
    "grep"
    "sed"
    "gawk"
    "tar"))
