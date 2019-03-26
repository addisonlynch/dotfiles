"""tlist.py

Obtain a list of the available tmuxp environments

Set TMUXP_DIR to directory of tmuxp source files

Note: this script does not recurse into subdirectories
"""
from string import Formatter

import datetime
import glob
import os
import libtmux


TMUXP_DIR = "~/.tmuxp"


class style():
    # ANSI terminal colors
    BLACK = '\033[30m'
    RED = '\033[31m'
    GREEN = '\033[32m'
    YELLOW = '\033[33m'
    BLUE = '\033[34m'
    MAGENTA = '\033[35m'
    CYAN = '\033[36m'
    WHITE = '\033[37m'
    UNDERLINE = '\033[4m'
    BOLD = '\033[1m'
    RESET = '\033[0m'


def get_tmux_sessions():
    server = libtmux.Server()
    return server.list_sessions()


def get_tmux_session_names():
    return [session.name for session in get_tmux_sessions()]


def get_config_files():
    files = []
    os.chdir(os.path.expanduser(TMUXP_DIR))
    for file in glob.glob("*.yaml"):
        files.append(file.split('.')[0])
    return files


def print_output():
    active_session_names = get_tmux_session_names()
    active_sessions = get_tmux_sessions()
    all_sessions = get_config_files()

    print("AVAILABLE TMUXP SESSIONS")
    print()
    for session in all_sessions:
        if session in active_session_names:
            fs = [s for s in active_sessions if s.name == session][0]
            up_str = "RUNNING %s" % uptime(int(fs._info["session_created"]))
            print(style.GREEN+style.BOLD+fs.name+style.RESET+" - "+up_str)
        else:
            print(session)
    print()


def uptime(total_seconds):
    now = datetime.datetime.now()
    created = datetime.datetime.fromtimestamp(total_seconds)
    return strfdelta(now-created)


def strfdelta(tdelta, fmt='{D:02}d {H:02}h {M:02}m {S:02}s', inputtype='timedelta'):
    """Convert a datetime.timedelta object or a regular number to a custom-
    formatted string, just like the stftime() method does for datetime.datetime
    objects.

    The fmt argument allows custom formatting to be specified.  Fields can
    include seconds, minutes, hours, days, and weeks.  Each field is optional.

    Some examples:
        '{D:02}d {H:02}h {M:02}m {S:02}s' --> '05d 08h 04m 02s' (default)
        '{W}w {D}d {H}:{M:02}:{S:02}'     --> '4w 5d 8:04:02'
        '{D:2}d {H:2}:{M:02}:{S:02}'      --> ' 5d  8:04:02'
        '{H}h {S}s'                       --> '72h 800s'

    The inputtype argument allows tdelta to be a regular number instead of the
    default, which is a datetime.timedelta object.  Valid inputtype strings:
        's', 'seconds',
        'm', 'minutes',
        'h', 'hours',
        'd', 'days',
        'w', 'weeks'
    """

    # Convert tdelta to integer seconds.
    if inputtype == 'timedelta':
        remainder = int(tdelta.total_seconds())
    elif inputtype in ['s', 'seconds']:
        remainder = int(tdelta)
    elif inputtype in ['m', 'minutes']:
        remainder = int(tdelta)*60
    elif inputtype in ['h', 'hours']:
        remainder = int(tdelta)*3600
    elif inputtype in ['d', 'days']:
        remainder = int(tdelta)*86400
    elif inputtype in ['w', 'weeks']:
        remainder = int(tdelta)*604800

    f = Formatter()
    desired_fields = [field_tuple[1] for field_tuple in f.parse(fmt)]
    possible_fields = ('W', 'D', 'H', 'M', 'S')
    constants = {'W': 604800, 'D': 86400, 'H': 3600, 'M': 60, 'S': 1}
    values = {}
    for field in possible_fields:
        if field in desired_fields and field in constants:
            values[field], remainder = divmod(remainder, constants[field])
    return f.format(fmt, **values)


if __name__ == '__main__':
    print_output()
