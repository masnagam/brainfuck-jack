set -eu

PROGNAME=$(basename $0)
USER_NAME=devenv

VERBOSE=0

help() {
  cat <<EOF >&2
Entry point of the devenv container

USAGE:
  $PROGNAME -h | --help

OPTIONS:
  -v, --verbose <verbose> [default: $VERBOSE]
    Verbose level.

ARGUMENTS:
  <script>
    A script to be executed by the $USER_NAME user in the container.
EOF
  exit 0
}

log() {
  echo "$1" >&2
}

vlog() {
  if [ $VERBOSE -ge $1 ]
  then
    log "LOG($1): $2"
  fi
}

error() {
  log "ERROR: $1"
  exit 1
}

while [ $# -gt 0 ]
do
  case "$1" in
    '-h' | '--help')
      help
      ;;
    '-v' | '--verbose')
      VERBOSE=$2
      shift 2
      ;;
    *)
      break
      ;;
  esac
done

SCRIPT="$@"

if [ -z "$SCRIPT" ]
then
  SCRIPT='bash'
fi

USER_UID=$(ls -ld . | cut -d ' ' -f 3)
if getent passwd $USER_UID >/dev/null
then
   USER_UID=$(getent passwd $USER_UID | cut -d ':' -f 3)
fi

USER_GID=$(ls -ld . | cut -d ' ' -f 4)
if getent group $USER_GID >/dev/null
then
  USER_GID=$(getent group $USER_GID | cut -d ':' -f 3)
fi

vlog 1 "Creating a user account for $USER_NAME with $USER_UID:$USER_GID..."
groupadd -o -g $USER_GID $USER_NAME
useradd -o -m -g $USER_GID -u $USER_UID $USER_NAME
# The user can do anything inside the container.
# So, we STRONGLY recommend you NOT to mount sensitive files onto the container.
cat >/etc/sudoers.d/devenv <<EOF
$USER_NAME ALL=(ALL) NOPASSWD: ALL
EOF

vlog 1 "Run \`$SCRIPT\`"
exec gosu $USER_NAME sh -c "$SCRIPT"
