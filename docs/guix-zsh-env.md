# Guix + Zsh Shell Environment

## Overview

The user toolchain (rust, gcc, git, etc.) is managed by GNU Guix and lives in
`~/.guix-profile`. Zsh sources that profile so PATH, certs, locale, and
Rust-specific vars are available. A subset of the exported vars is deliberately
**un-set** afterward so Guix's C libraries never override the system's when
building older software from source (e.g. ruby 3.0.7 via mise).

## Guix Profiles (there are two)

| Path | What it holds | Updated by |
|---|---|---|
| `~/.config/guix/current` → `…/current-guix` | the `guix` command itself | `guix pull` |
| `~/.guix-profile` → `…/guix-profile` | user packages (rust, gcc-toolchain, git, …) | `guix package -u` |

Config:
- `~/.config/guix/channels.scm` — channel is `codeberg.org/guix/guix`, branch
  `master`, unpinned.
- `~/.config/guix/manifest.scm` — the user package manifest (zsh, rust,
  `rust:cargo`, rust-analyzer, gcc-toolchain, …).

Both profile `bin` dirs must be on PATH. The guix tooling dir
(`~/.config/guix/current/bin`) is added explicitly after sourcing the profile.

## Environment Variables from the Profile

Guix regenerates `~/.guix-profile/etc/profile` on every profile change to emit
the "search-paths" exports. Sourcing it sets, among others:

`PATH` (profile `bin`/`sbin`), `GUIX_LOCPATH`, `SSL_CERT_FILE`,
`GIT_SSL_CAINFO`, `CARGO_HTTP_CAINFO`, `RUST_SRC_PATH`, `TERMINFO_DIRS`,
`TREE_SITTER_GRAMMAR_PATH`, `ACLOCAL_PATH`, `GUILE_EXTENSIONS_PATH`,
`OCAMLPATH`, `CAML_LD_LIBRARY_PATH`, `CMAKE_PREFIX_PATH`,
`C_INCLUDE_PATH`, `CPLUS_INCLUDE_PATH`, `LIBRARY_PATH`,
`OBJC_INCLUDE_PATH`, `OBJCPLUS_INCLUDE_PATH`.

Most of these are desirable. The last six are not (see below).

## The C-Library Leakage Risk

`cc` resolves to the **system** compiler (`/usr/bin/cc → gcc-15`), while `gcc`
resolves to the **Guix** compiler (`~/.guix-profile/bin/gcc`). Most build
scripts (autoconf, ruby's `extmk`, mise source builds) invoke `cc`, not `gcc`.

If `C_INCLUDE_PATH` is set to `~/.guix-profile/include`, the **system** `cc`
searches it first:

```
$ C_INCLUDE_PATH="$HOME/.guix-profile/include" /usr/bin/cc -E -Wp,-v - < /dev/null
#include <...> search starts here:
 /home/kevingathuku/.guix-profile/include      ← Guix glibc/openssl/sqlite/… headers
 /usr/lib/gcc/x86_64-linux-gnu/15/include
 /usr/local/include
 /usr/include/x86_64-linux-gnu
 /usr/include
```

That overrides the system C library with Guix's (newer glibc, different
openssl/sqlite ABIs), which breaks older source builds — ruby 3.0.7 (mise,
built from source via `cc`) is the known victim. `CMAKE_PREFIX_PATH` causes the
same class of leak for cmake-based builds.

Ruled out: a loader/libc ABI mismatch. The binary's interpreter and the
profile's `libc.so.6` both resolve to the same Guix store glibc
(`m31vlvwm…-glibc-2.41`). Forcing `LD_LIBRARY_PATH` to that store dir does not
fix the crash (see Known Issues).

## Shell Sourcing Design

Two files, because zsh has two relevant startup paths:

- **`~/.zprofile`** (login shells) — sources the profile, then unsets the six
  leak vars. Descendants (tmux panes, scripts) inherit the result.
- **`~/.zshrc`** (interactive shells) — a sentinel-guarded fallback for
  non-login interactive shells (tmux default, some terminals). It re-sources
  only if `GUIX_LOCPATH` is empty (i.e. `.zprofile` didn't run), then unsets the
  same six vars.

The sentinel avoids double-sourcing: a login-interactive shell sources once in
`.zprofile`, and the `.zshrc` guard sees `GUIX_LOCPATH` already set and skips.
tmux panes inherit the env from the parent login shell, so the guard skips there
too — no duplicated `PATH`/`GUIX_LOCPATH` entries.

Both blocks unconditionally unset after sourcing:

```
unset LIBRARY_PATH C_INCLUDE_PATH CPLUS_INCLUDE_PATH OBJC_INCLUDE_PATH OBJCPLUS_INCLUDE_PATH CMAKE_PREFIX_PATH
```

Net effect: all the good Guix vars are present; the system `cc` sees only
system headers/libs, exactly as before Guix was installed.

## Resolution

Files (stow-managed under `zsh/`):

- `zsh/.zprofile` (new) — login-shell sourcing + protective unsets.
- `zsh/.zshrc` — the old Guix block replaced by the sentinel guard; removed the
  stray pre-`export GUIX_LOCPATH` that was duplicating entries.

Deployed with:

```bash
stow -R zsh          # run from ~/dotfiles; creates ~/.zprofile, re-creates ~/.zshrc
```

## Verification

Clean-env shells (no inherited Guix vars), so the sentinel logic is exercised:

```bash
# login shell (sources .zprofile, not .zshrc)
env -i HOME="$HOME" PATH=/usr/bin:/bin SHELL=/usr/bin/zsh \
  zsh -l -c 'print -r -- "CMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH:-<unset>}";
             print -r -- "C_INCLUDE_PATH=${C_INCLUDE_PATH:-<unset>}";
             print -r -- "GUIX_LOCPATH=$GUIX_LOCPATH"'

# non-login interactive (sources .zshrc guard)
env -i HOME="$HOME" PATH=/usr/bin:/bin SHELL=/usr/bin/zsh TERM=dumb \
  zsh -i -c 'print -r -- "CMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH:-<unset>}";
             print -r -- "GUIX_LOCPATH=$GUIX_LOCPATH"'
```

Both print the six C-include/library vars as `<unset>` and `GUIX_LOCPATH` set.
The system-compiler check (no `.guix-profile` in the search list):

```bash
/usr/bin/cc -E -Wp,-v - < /dev/null 2>&1 | sed -n '/search starts here/,/End of search/p'
```

Lists only `/usr/lib/gcc/…`, `/usr/local/include`, `/usr/include*`.

Syntax check:

```bash
zsh -n ~/dotfiles/zsh/.zshrc
zsh -n ~/dotfiles/zsh/.zprofile
```

## Guix Workflow and the Generic Hint

Keep current:

```bash
guix pull           # advance guix tooling (~/.config/guix/current)
guix package -u     # upgrade user packages (~/.guix-profile)
```

After any `guix package` transaction that changes search-paths, guix prints:

> Consider setting the necessary environment variables by running:
> `GUIX_PROFILE="$HOME/.guix-profile"; . "$GUIX_PROFILE/etc/profile"; unset GUIX_PROFILE`

This hint is **generic and unsuppressible** — guix cannot tell that the shell
already sources the profile. It will reappear after every upgrade regardless of
this setup. Open a new terminal (or run the snippet once in the current shell)
and ignore it; the env is already correct in fresh shells.

## Cargo-Installed Binaries

`cargo install` (using Guix's cargo 1.93.0) places binaries in `~/.cargo/bin`,
which is on PATH via `.zshrc`:

```sh
export PATH="$HOME/.cargo/bin:$PATH"
[[ -f "$HOME/.cargo/env" ]] && . "$HOME/.cargo/env"   # rustup-style; absent with Guix cargo
```

