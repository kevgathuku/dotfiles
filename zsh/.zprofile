# ~/.zprofile - zsh login shell init (sourced before .zshrc)
# Source the Guix profile so PATH, certs, locale, RUST_SRC_PATH, etc. are
# inherited by all descendants. The C-compiler include/library paths and
# CMAKE_PREFIX_PATH are then deliberately cleared so system-compiler builds
# (e.g. ruby via mise) keep using the system C libraries instead of Guix's
# (which breaks older source builds).
if [[ "$(uname)" == 'Linux' ]]; then
	GUIX_PROFILE="$HOME/.guix-profile"
	if [[ -f "$GUIX_PROFILE/etc/profile" ]]; then
		. "$GUIX_PROFILE/etc/profile"
		export PATH="$HOME/.config/guix/current/bin${PATH:+:$PATH}"
		unset LIBRARY_PATH C_INCLUDE_PATH CPLUS_INCLUDE_PATH OBJC_INCLUDE_PATH OBJCPLUS_INCLUDE_PATH CMAKE_PREFIX_PATH
		export SSL_CERT_FILE="$HOME/.guix-profile/etc/ssl/certs/ca-certificates.crt"
		export GIT_SSL_CAINFO="$HOME/.guix-profile/etc/ssl/certs/ca-certificates.crt"
	fi
	unset GUIX_PROFILE
fi
