#: Keep the OS window title showing the working directory of the active tab.
#:
#: Enabled from kitty.conf with:  watcher os_window_title.py
#:
#: kitty normally mirrors the active window's title into the OS window title,
#: so it shows whatever the shell or the running program last set. Calling
#: set_os_window_title() from python sets title_is_overriden, after which
#: programs can no longer change it, so this survives nvim, ssh, and the
#: running-command title that shell integration sets.

import os
from typing import TYPE_CHECKING, Any

from kitty.fast_data_types import set_os_window_title

if TYPE_CHECKING:
    from kitty.boss import Boss
    from kitty.window import Window

HOME = os.path.expanduser('~')


def format_cwd(cwd: str) -> str:
    #: /home/you/src/gecko -> src/gecko. For ~/src/gecko instead use
    #: "'~' + cwd[len(HOME):]", for just gecko use os.path.basename(cwd).
    if cwd == HOME:
        return '~'
    if cwd.startswith(HOME + os.sep):
        return cwd[len(HOME) + 1:]
    return cwd


def sync(boss: 'Boss', window: 'Window') -> None:
    tm = boss.os_window_map.get(window.os_window_id)
    if tm is None:
        return
    active = tm.active_window
    if active is None:
        return
    #: cwd_of_child follows the foreground process, so it tracks cd, and is
    #: empty over ssh, where we fall back to whatever the remote side set.
    title = format_cwd(active.cwd_of_child or '') or active.title
    if title:
        set_os_window_title(active.os_window_id, title)


def on_focus_change(boss: 'Boss', window: 'Window', data: dict[str, Any]) -> None:
    sync(boss, window)


def on_title_change(boss: 'Boss', window: 'Window', data: dict[str, Any]) -> None:
    sync(boss, window)


def on_cmd_startstop(boss: 'Boss', window: 'Window', data: dict[str, Any]) -> None:
    sync(boss, window)


def on_resize(boss: 'Boss', window: 'Window', data: dict[str, Any]) -> None:
    #: Also fires once when a window is first created.
    sync(boss, window)


def on_close(boss: 'Boss', window: 'Window', data: dict[str, Any]) -> None:
    sync(boss, window)
