;; Guix package manifest
;; Install with: guix package --manifest=$HOME/.config/guix/manifest.scm

(specifications->manifest
  '(;; Shells & Terminal
    "zsh"
    "zsh-syntax-highlighting"
    "zsh-autopair"
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
    ;; "erlang"  ; managed by mise
    ;; "elixir"  ; managed by mise (requires erlang)
    "go"
    ;; "node"  ; managed by mise
    ;; "deno"  ; managed by mise
    "ocaml"
    "opam"
    "guile"
    "rust"
    "rust:cargo"
    "rust-analyzer"
    ;; "python"  ; managed by mise
    ;; "ruby"  ; managed by mise



    ;; Build Tools
    "cmake"
    "ninja"
    "autoconf"
    "automake"
    "make"

    ;; CLI Utilities
    "curl"
    "wget"
    "htop"
    "jq"
    "awscli"
    "difftastic"
    "diff-so-fancy"
    "direnv"
    "stow"
    "gnupg"
    "unzip"
    "dos2unix"
    "tldr"
    "curlie"
    "mosh"
    "socat"
    "rlwrap"
    "openvpn"

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
    "tar"

    ;; X11
    "setxkbmap"
    "xsel"

    ;; Certificates
    "nss-certs"

    ;; Locales
    "glibc-locales"))
