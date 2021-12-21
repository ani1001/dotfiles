# Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

import os, re, shutil, socket, subprocess
from libqtile import bar, hook, layout, qtile, widget
from libqtile.config import EzClick as Click, EzDrag as Drag, Group, EzKey as Key, Match, Rule, Screen
from libqtile.lazy import lazy
from typing import List  # noqa: F401
from libqtile.widget import Spacer

home = os.path.expanduser('~')
terminal = "kitty"

keys = [
    # Switch between windows
    Key("M-h", lazy.layout.left(), desc="Move focus to left"),
    Key("M-l", lazy.layout.right(), desc="Move focus to right"),
    Key("M-j", lazy.layout.down(), desc="Move focus down"),
    Key("M-k", lazy.layout.up(), desc="Move focus up"),
    Key("M-<space>", lazy.layout.next(),
        desc="Move window focus to other window"),

    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key("M-S-h", lazy.layout.shuffle_left(),
        desc="Move window to the left"),
    Key("M-S-l", lazy.layout.shuffle_right(),
        desc="Move window to the right"),
    Key("M-S-j", lazy.layout.shuffle_down(),
        desc="Move window down"),
    Key("M-S-k", lazy.layout.shuffle_up(), desc="Move window up"),

    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key("M-C-h", lazy.layout.grow_left(),
        desc="Grow window to the left"),
    Key("M-C-l", lazy.layout.grow_right(),
        desc="Grow window to the right"),
    Key("M-C-j", lazy.layout.grow_down(),
        desc="Grow window down"),
    Key("M-C-k", lazy.layout.grow_up(), desc="Grow window up"),
    Key("M-n", lazy.layout.normalize(), desc="Reset all window sizes"),

    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key("M-S-<Return>", lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack"),
    Key("M-<Return>", lazy.spawn(terminal), desc="Launch terminal"),

    # Toggle between different layouts as defined below
    Key("M-<Tab>", lazy.next_layout(), desc="Toggle between layouts"),
    Key("M-w", lazy.window.kill(), desc="Kill focused window"),

    Key("M-C-r", lazy.restart(), desc="Restart Qtile"),
    Key("M-C-q", lazy.shutdown(), desc="Shutdown Qtile"),
    #Key("M-r", lazy.spawncmd(),
        #desc="Spawn a command using a prompt widget"),

    # Keybindings to launch user defined programs
    Key("A-d", lazy.spawn("dmenu_run"), desc="Launch dmenu"),
    Key("A-e", lazy.spawn("emacs"), desc="Launch emacs"),
    Key("A-f", lazy.spawn("pcmanfm"), desc="Launch pcmanfm"),
    Key("A-m", lazy.spawn("/usr/local/src/thunderbird/thunderbird"), desc="Launch thunderbird"),
    Key("A-n", lazy.spawn("nitrogen"), desc="Launch nitrogen"),
    Key("A-r", lazy.spawn("rofi -show run"), desc="Launch rofi"),
    Key("A-t", lazy.spawn("urxvtc"), desc="Launch rxvt-unicode"),
    Key("A-w", lazy.spawn("firefox"), desc="Launch firefox"),
    Key("A-C-w", lazy.spawn("/usr/local/src/waterfox/waterfox"), desc="Launch waterfox"),
    Key("A-C-s", lazy.spawn("/usr/local/src/sublime_text/sublime_text"), desc="Launch sublime_text"),
]

groups = [
    Group("web",   layout="max",        matches=[Match(wm_class=["firefox", "vivaldi-stable"])]),
    Group("dev",   layout="monadtall",  matches=[Match(wm_class=["Emacs", "Sublime_text"])]),
    Group("sys",   layout="monadtall",  matches=[Match(wm_class=["Lxappearance", "Nitrogen"])]),
    Group("doc",   layout="monadtall",  matches=[Match(wm_class=["qpdfview"])]),
    Group("chat",  layout="max",        matches=[Match(wm_class=["TelegramDesktop"])]),
    Group("game",  layout="ratiotile"),
    Group("media", layout="max",        matches=[Match(wm_class=["Deadbeef"]), Match(title=["VLC media player"])]),
    Group("gfx",   layout="tile"),
]

for k, group in zip(["1", "2", "3", "4", "5", "6", "7", "8"], groups):
    keys.append(Key("M-"+(k), lazy.group[group.name].toscreen()))
    keys.append(Key("M-S-"+(k), lazy.window.togroup(group.name)))

def init_layout_theme():
    return {
            "margin": 2,
            "border_width": 2,
            "border_focus": '#5e81ac',
            "border_normal": '#4c566a'
            }

layout_theme = init_layout_theme()

layouts = [
    # layout.Columns(border_focus_stack=['#d75f5f', '#8f3d3d'], border_width=4),
    layout.Max(**layout_theme),
    # Try more layouts by unleashing below layouts.
    # layout.Stack(num_stacks=2, **layout_theme),
    # layout.Bsp(),
    # layout.Matrix(**layout_theme),
    layout.MonadTall(margin=0, border_width=2, border_focus='#5e81ac', border_normal='#4c566a'),
    # layout.MonadWide(margin=0, border_width=2, border_focus='#5e81ac', border_normal='#4c566a'),
    layout.RatioTile(**layout_theme),
    layout.Tile(**layout_theme),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]

#Colors for the bar
def init_colors():
    return [["#2e3440", "#2e3440"], # color 0  dark grayish blue
            ["#2e3440", "#2e3440"], # color 1  dark grayish blue
            ["#d8dee9", "#d8dee9"], # color 2  grayish blue
            ["#e5e9f0", "#e5e9f0"], # color 3  light grayish blue
            ["#8fbcbb", "#8fbcbb"], # color 4  grayish cyan
            ["#88c0d0", "#88c0d0"], # color 5  desaturated cyan
            ["#81a1c1", "#81a1c1"], # color 6  desaturated blue
            ["#5e81ac", "#5e81ac"], # color 7  dark moderate blue
            ["#d08770", "#d08770"], # color 8  desaturated red
            ["#ebcb8b", "#ebcb8b"], # color 9  soft orange
            ["#a3be8c", "#a3be8c"], # color 10 desaturated green
            ["#b48ead", "#b48ead"]] # color 11 grayish magenta

colors = init_colors()

widget_defaults = dict(
    font='sans',
    fontsize=12,
    padding=3,
    background=colors[1],
    foreground=colors[2]
)
extension_defaults = widget_defaults.copy()

screens = [
    Screen(
        top=bar.Bar(
            [
                widget.Sep(
                    linewidth=1,
                    padding=10,
                    foreground=colors[2],
                    background=colors[1]
                ),
                widget.Image(
                    filename="~/.config/qtile/icons/python.png",
                    iconsize=9,
                    background=colors[1],
                    mouse_callbacks={'Button1': lambda : qtile.cmd_spawn('rofi -show run')}
                ),
                widget.Sep(
                    linewidth=1,
                    padding=10,
                    foreground=colors[2],
                    background=colors[1]
                ),
                widget.GroupBox(
                    active=colors[11],
                    hide_unused=False,
                    highlight_method='line',
                    inactive=colors[3],
                    this_current_screen_border=colors[9]
                ),
                widget.Sep(
                    background=colors[1],
                    foreground=colors[2],
                    linewidth=1,
                    padding=10
                ),
                widget.CurrentLayoutIcon(
                    background=colors[1],
                    foreground=colors[3],
                    padding=0,
                    scale=0.65
                ),
                widget.Sep(
                    background=colors[1],
                    foreground=colors[2],
                    linewidth=1,
                    padding=10
                ),
                widget.CurrentLayout(
                    background=colors[1],
                    foreground=colors[3],
                    font='sans bold'
                ),
                widget.Sep(
                    background=colors[1],
                    foreground=colors[2],
                    linewidth=1,
                    padding=10
                ),
                widget.Spacer(),
                widget.KeyboardLayout(
                    background=colors[1],
                    foreground=colors[3]
                ),
                widget.Sep(
                    background=colors[1],
                    foreground=colors[2],
                    linewidth=1,
                    padding=10
                ),
                widget.TextBox(
                    background=colors[1],
                    foreground=colors[3],
                    padding = 0,
                    text=" "
                ),
                widget.Clock(
                    background=colors[1],
                    foreground=colors[3],
                    format='%Y-%m-%d %a %I:%M %p'
                ),
            ],
            22,
            opacity=0.9
        ),
        bottom=bar.Bar(
            [
                widget.WindowName(max_chars=50),
                widget.Spacer(),
                widget.Systray(),
                widget.Sep(
                    background=colors[1],
                    foreground=colors[2],
                    linewidth=1,
                    padding=10
                ),
                widget.TextBox(
                    background=colors[1],
                    foreground=colors[3],
                    padding = 0,
                    text=" "
                ),
                widget.Memory(
                    background=colors[1],
                    foreground=colors[3],
                    format="{MemUsed: .0f}{mm}",
                    update_interval=1.0
                ),
                widget.Sep(
                    background=colors[1],
                    foreground=colors[2],
                    linewidth=1,
                    padding=10
                ),
                widget.TextBox(
                    background=colors[1],
                    foreground=colors[3],
                    padding = 0,
                    text="CPU: "
                ),
                widget.CPUGraph(
                    background=colors[1],
                    border_color=colors[2],
                    border_width=0,
                    core="all",
                    fill_color=colors[6],
                    foreground=colors[2],
                    graph_color=colors[6],
                    line_width=1,
                    type='linefill'
                ),
                widget.Sep(
                    background=colors[1],
                    foreground=colors[2],
                    linewidth=1,
                    padding=10
                ),
                widget.TextBox(
                    background=colors[1],
                    foreground=colors[3],
                    padding = 0,
                    text="NET: "
                ),
                widget.NetGraph(
                    background=colors[1],
                    bandwidth="down",
                    border_color=colors[2],
                    border_width=0,
                    fill_color=colors[5],
                    foreground=colors[2],
                    graph_color=colors[5],
                    interface="auto",
                    line_width=1,
                    padding=0,
                    type='linefill'
                ),
            ],
            22,
            opacity=0.9
        ),
    ),
]

# Drag floating layouts.
mouse = [
    Drag("M-1", lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag("M-3", lazy.window.set_size_floating(),
         start=lazy.window.get_size()),
    Click("M-2", lazy.window.bring_to_front())
]

main = None
dgroups_key_binder = None
dgroups_app_rules = []  # type: List
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(float_rules=[
    # Run the utility of `xprop` to see the wm class and name of an X client.
    *layout.Floating.default_float_rules,
    Match(wm_class='confirmreset'),  # gitk
    Match(wm_class='makebranch'),  # gitk
    Match(wm_class='maketag'),  # gitk
    Match(wm_class='ssh-askpass'),  # ssh-askpass
    Match(title='branchdialog'),  # gitk
    Match(title='pinentry'),  # GPG key password entry
    ],
    border_focus=colors[7] [0]
)
auto_fullscreen = True
focus_on_window_activation = "urgent"
reconfigure_screens = True

@hook.subscribe.restart
def cleanup():
    shutil.rmtree(os.path.expanduser('~/.config/qtile/__pycache__'))

@hook.subscribe.shutdown
def killall():
    shutil.rmtree(os.path.expanduser('~/.config/qtile/__pycache__'))
    subprocess.Popen(['killall', 'urxvtd', 'lxpolkit', 'nitrogen', 'picom'])

@hook.subscribe.startup_once
def start_once():
    home = os.path.expanduser('~')
    subprocess.call([home + '/.config/qtile/autostart.sh'])

@hook.subscribe.startup
def start_always():
    # Set the cursor to something sane in X
    subprocess.Popen(['xsetroot', '-cursor_name', 'left_ptr'])

@hook.subscribe.client_new
def set_floating(window):
    if (window.window.get_wm_transient_for()
            or window.window.get_wm_type() in floating_types):
        window.floating = True

floating_types = ["notification", "toolbar", "splash", "dialog"]

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
