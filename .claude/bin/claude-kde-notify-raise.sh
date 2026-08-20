#!/usr/bin/env bash
# Notification hook: make kitty's Task Manager entry demand attention (KDE
# highlights it) when Claude is waiting for input, with NO popup. We send a
# silent terminal bell (kitty has enable_audio_bell off) to the session's pty;
# kitty turns that into the Wayland urgency hint while it is unfocused, and KDE
# highlights the task until the window is focused. The highlight clears on
# focus automatically, so no separate clear step is needed.
set -euo pipefail

# Walk our own ancestry to find the session's controlling pty. pgrep is not
# reliable here because several claude instances may be running.
find_pts() {
  local pid=$$ ppid comm t
  while [ "${pid:-1}" -gt 1 ]; do
    read -r ppid comm t < <(ps -o ppid=,comm=,tty= -p "$pid" 2>/dev/null) || return 1
    case "$t" in
      pts/*) printf '/dev/%s' "$t"; return 0 ;;
    esac
    pid="$ppid"
  done
  return 1
}

# Drain stdin (hook payload) so the writer never blocks; we do not need it.
cat >/dev/null 2>&1 || true

dev=$(find_pts) || exit 0
[ -w "$dev" ] || exit 0
printf '\a' >"$dev" 2>/dev/null || true
exit 0
