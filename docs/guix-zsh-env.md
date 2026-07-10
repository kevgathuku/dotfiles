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

`mempal` is installed this way (see Known Issues for the build flag it needs).

## Known Issues

### `mempal` release build crashes (`free(): invalid pointer` / SIGSEGV) — RESOLVED

A plain `cargo install mempal --locked` produces a binary that aborts on every
subcommand that opens the DB (`doctor`, `init`, `ingest`, `search`, …) with
`free(): invalid pointer`, leaving a 0-byte `~/.mempal/palace.db`.

**Root cause** (confirmed via gdb on a `debug=true, strip=false` rebuild):
mempal's `Cargo.toml` sets `[profile.release] opt-level = "z"`, which cargo
forwards to build scripts as `OPT_LEVEL=z`. The `cc` crate then compiles the
**bundled `sqlite3.c`** (from `libsqlite3-sys`, pulled by `rusqlite`'s
`bundled` feature) with **`gcc-15 -Oz`**, and gcc-15 miscompiles the sqlite3
amalgamation. The corruption fires in `sqlite3_overload_function("MATCH")`
during `openDatabase`, on every connection open. The abort stack:

```
free ← sqlite3_free ← sqlite3_overload_function
     ← sqlite3RegisterPerConnectionBuiltinFunctions ← openDatabase
     ← rusqlite::Connection::open ← mempal_store_sqlite::Database::open
```

Ruled out:
- **glibc/loader mismatch** — the binary's interpreter and its runtime
  `libc.so.6` are the same Guix store glibc (`m31vlvwm…-glibc-2.41`); forcing
  `LD_LIBRARY_PATH` to that store dir does not help.
- **mempal version** — reproduces on 0.7.0, 0.8.0, 0.9.0.
- **LTO** — `CARGO_PROFILE_RELEASE_LTO=false` still crashes.
- **`-O2`** — `CFLAGS="-O2"` changes the symptom to SIGSEGV (still crashes);
  gcc-15 miscompiles `sqlite3.c` at both `-Oz` and `-O2`. Only `-O0` (the dev
  profile) is safe.

**Fix** — keep Rust at release, force `sqlite3.c` to `-O0`:

```bash
CFLAGS="-O0" cargo install mempal --locked --force
```

Verified end-to-end: `doctor`, `init`, `ingest`, `compress`, `status`, and
`search` (both BM25 keyword `[0.147]` and vector semantic `[-0.148]` via
model2vec + sqlite-vec) all succeed; `palace.db` initializes to a real size.

Trade-off: sqlite runs unoptimized (slower DB ops); Rust code stays
release-optimized. If a faster build is wanted, try
`CFLAGS="-O2 -fno-tree-vectorize"` (disables gcc's auto-vectorization, the
usual sqlite+gcc culprit) — untested here. Revisit once gcc-15 or libsqlite3-sys
ships a fix; until then, **always pass `CFLAGS="-O0"` when reinstalling
mempal**, or the crash returns.

### `mise install erlang` fails ("No curses library functions found") — RESOLVED (by moving erlang to Guix)

`mise install erlang` (kerl source build of OTP) died in `erts/configure`:

```
checking for tgetent in -ltinfo... no
checking for tgetent in -lncurses... no
...
configure: error: No curses library functions found
```

**Root cause** — the same Guix/system compiler mixup described above. autoconf
picks the C compiler by searching PATH in order `gcc cc …` (when `CC` is unset).
`gcc` resolves to the **Guix** gcc-16 (`~/.guix-profile/bin/gcc`), whose built-in
search dirs are `/gnu/store/…` only — it cannot see apt-installed
`/usr/lib/x86_64-linux-gnu/libncurses.so` / `libtinfo.so`, so every curses link
check fails. (`cc` → system gcc-15 would work, but autoconf tries `gcc` first.)

Confirmed: `~/.guix-profile/bin/gcc -print-search-dirs` lists only `/gnu/store`
paths; a trivial `#include <openssl/ssl.h>` + `-lssl` fails under Guix gcc even
with `-I/usr/include -L/usr/lib/x86_64-linux-gnu` (multiarch
`/usr/include/x86_64-linux-gnu/openssl/opensslconf.h` is still missed). The
system `/usr/bin/gcc` (→ gcc-15) links both fine. The `.zprofile`/`.zshrc`
unsets don't help: kerl inherits the *launching* shell's env, and `cc` is not
the issue — `gcc` is, because autoconf prefers it.

**Resolution — move erlang (and the BEAM ecosystem) to Guix native packages.**

erlang is the *opposite* case to ruby 3.0.7: it is current and happy with Guix's
newer openssl/ncurses, so it belongs on the Guix toolchain, not forced onto the
system one. Instead of working around the compiler mixup per-tool (an
`install_env` with `CC=/usr/bin/gcc` would build erl against *system* libs but
then face a runtime ABI risk — erl linked to system `libssl.so.3` while Guix
openssl headers were used), the clean fix is to drop the source build entirely.
Guix ships a prebuilt OTP whose runtime libs are RPATH-correct, so there is no
compiler selection, no lib-resolution, and no ABI mismatch to manage.

Guix packages the whole coordinated set (versions as of this writing):

| tool    | Guix version | depends on (Guix graph)        |
|---------|--------------|--------------------------------|
| erlang  | 28.4.3       | ncurses, openssl, wxwidgets, … |
| rebar3  | 3.24.0       | erlang@28.4.3                  |
| elixir  | 1.19.5       | erlang@28.4.3, rebar3@3.24.0   |

Files changed:

- `guix/.config/guix/manifest.scm` — uncommented `"erlang"`, `"elixir"`; added
  `"rebar3"`. (`~/.config/guix` is a dir-level symlink to the repo's
  `guix/.config/guix`, so the edit is live on deploy — no `stow` step needed.)
- `mise/.config/mise/config.toml` — removed `erlang` and `rebar` (+ the
  `install_env` workaround). Global mise now holds only dotnet/node/ruby.
- Removed the kerl build: `mise uninstall erlang@29.0.3 rebar@3.27.0` and cleared
  `~/.cache/mise/erlang` + `~/.local/share/mise/installs/{erlang,rebar}`
  (~GB freed).

Installed with `guix package -i erlang elixir rebar3` (additive, not
`--manifest`, to avoid surprise-removing anything outside the manifest). The
generic "Consider setting the necessary environment variables" hint prints
afterward — unsuppressible and already handled by `.zprofile`/`.zshrc`; ignore
it (see "Guix Workflow and the Generic Hint" above).

**Runtime lib resolution is RPATH-correct, no `LD_LIBRARY_PATH`.** This is the
key advantage over a mise source build. The crypto NIF carries its own RUNPATH:

```
$ readelf -d …/crypto-5.8.3/priv/lib/crypto.so | grep RUNPATH
RUNPATH: /gnu/store/…-openssl-3.5.7/lib:/usr/local/lib:…:/gnu/store/…-glibc-2.41/lib:…
$ ldd …/crypto.so | grep libcrypto
  libcrypto.so.3 => /gnu/store/…-openssl-3.5.7/lib/libcrypto.so.3
```

The Guix store path is first, so Guix openssl wins at runtime regardless of the
dynamic-loader cache pointing at `/usr/lib/…/libssl.so.3`. Verified with all
leak vars unset and `LD_LIBRARY_PATH` empty: `ssl:start(), ssl:connect(...)`
succeeds → TLS works with zero env help.

Verified: `erl -version` → ERTS 16.3.1 (OTP 28); `rebar3 version` → "rebar
3.24.0 on Erlang/OTP 28 Erts 16.3.1"; `elixir --version` → "Elixir 1.19.5
(compiled with Erlang/OTP 28)". All resolve to `~/.guix-profile/bin/`.

Trade-off: Guix tracks OTP **28**, not "latest" (29), so there is a ~one-major
version lag and no per-project erlang version pinning (Guix gives one global
version). Acceptable because the erlang+rebar3+elixir set is Guix-tested
together, which a self-assembled mise trio is not. Upgrade with the usual
`guix package -u`. The ruby case is unaffected — ruby 3.0.7 still needs the
system C libs, so the `.zprofile`/`.zshrc` unsets stay (and ruby stays in mise,
`compile = false`).

