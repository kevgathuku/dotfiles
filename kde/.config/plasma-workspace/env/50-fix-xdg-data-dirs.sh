# Ensure system data dirs are reachable for KDE Plasma themes, icons,
# and desktop shell packages.  The Guix user profile's etc/profile
# prepends ~/.guix-profile/share to XDG_DATA_DIRS but drops /usr/share
# when sourced from ~/.zprofile (before zzz-guix.sh sets the default).
# This script runs after startplasma imports the login-shell env, so we
# append /usr/share if it's missing.
case ":${XDG_DATA_DIRS}:" in
  *:/usr/share:*) ;;
  *) export XDG_DATA_DIRS="${XDG_DATA_DIRS:+${XDG_DATA_DIRS}:}/usr/local/share:/usr/share" ;;
esac
