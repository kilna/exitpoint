#!/bin/sh

set -u -e

# Set EXITPOINT to /exitpoint.sh if not already set
export EXITPOINT="${EXITPOINT:-/exitpoint.sh}"

exitpoint() {
  echo "$EXITPOINT triggered on signal $1" >&2
  exec 3<&- || true; # Close fifo
  [ "${tmpdir:-}" != "" ] && rm -rf $tmpdir || true # Cleanup temp dir
  exec "$EXITPOINT"
}

trap "exitpoint HUP" HUP
trap "exitpoint INT" INT
trap "exitpoint QUIT" QUIT
trap "exitpoint TERM" TERM

# Prefix a custom derived-container entrypoint if provided as env var
if [ "${ENTRYPOINT:-}" != '' ]; then
  set -- ${ENTRYPOINT} "$@"
fi

"$@"
export CMD_EXIT=$? # Should be exposed to exitpoint script

# Inspired by: https://unix.stackexchange.com/questions/68236/avoiding-busy-waiting-in-bash-without-the-sleep-command

export tmpdir=$(mktemp -d --tmpdir=/tmp)
mkfifo $tmpdir/exitpoint-fifo
exec 3<> $tmpdir/exitpoint-fifo # Open fifo as file descriptor 3

# Read the exitpoint-fifo for new data (which never comes), one second at a
# time, for forever. Creates an infinite loop without sleep subprocess nor the
# burn that comes with busy-waiting using no-op : shell commands)
while read -t 1 -u 3 var || true; do :; done

