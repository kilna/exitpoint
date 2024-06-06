#!/bin/sh

set -u -e

# Set EXITPOINT to /exitpoint.sh if not already set
export EXITPOINT="${EXITPOINT:-/exitpoint.sh}"

exitpoint() {
  echo "$EXITPOINT triggered on signal $1" >&2
  exec 3<&- || true; # Close fifo
  [ "${tmpdir:-}" != "" ] && rm -rf $tmpdir || true # Cleanup temp dir
  [ "${PID:-}" != "" ] && ps $PID >/dev/null && kill -s $1
  exec "$EXITPOINT"
}

for sig in SIGHUP SIGINT SIGQUIT SIGTERM; do
  trap "exitpoint $sig" $sig
done

# Run docker CMD as passed into entrypoint
background=0
wait=0
while [ $# -gt 0 ]; do case "$1" in
  --bg|-b)    background=1;;
  --wait|-w)  wait=1;;
  --debug|-d) set -x;;
  *)          break;;
esac; shift; done

# Prefix a custom derived-container entrypoint if provided as env var
if [ "${ENTRYPOINT:-}" != '' ]; then
  set -- "${ENTRYPOINT}" "$@"
fi

# Run the command...
if [ $# -gt 0 ]; then
  if [ $background -gt 0 ] || [ $wait -gt 0 ]; then
    "$@" &
    export PID=$$
  else
    "$@"
    export CMD_EXIT=$?
  fi
else
  # We had no command to run, just pretend we had success
  CMD_EXIT=0
fi

# Now we wait...

if [ $wait -gt 0 ]; then
  # Wait for the backgrounded process if that's how we're configured...
  wait $PID
  export CMD_EXIT=$?
  exec "$EXITPOINT"
fi

# Otherwise wait for a signal.

# Inspired by: https://unix.stackexchange.com/questions/68236/avoiding-busy-waiting-in-bash-without-the-sleep-command

export tmpdir=$(mktemp -d --tmpdir=/tmp)
mkfifo $tmpdir/exitpoint-fifo
exec 3<> $tmpdir/exitpoint-fifo # Open fifo as file descriptor 3

# Read the exitpoint-fifo for new data (which never comes), one second at a
# time, for forever. Creates an infinite loop without sleep subprocess nor the
# burn that comes with busy-waiting using no-op : shell commands)
while read -t 1 -u 3 var || true; do :; done

