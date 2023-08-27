import colors
import os
import subprocess
from libqtile import bar, layout, widget, qtile, hook
from libqtile.config import Click, Drag, Group, Key, KeyChord, Match, Screen
from libqtile.lazy import lazy
from qtile_extras import widget
from qtile_extras.widget.decorations import RectDecoration

mod = "mod4"
#Switch the commends below to have qtile guess your terminal
#you will also need to add "from libqtile.utils import guess_terminal" to the imports above
#terminal = guess_terminal()
terminal = "kitty"
emacs = "emacsclient -c -a 'emacs' "
editor = emacs
filemanager = emacs + "--eval '(dired nil)'"
mail = emacs + "--eval '(mu4e)'"
screenlocker = "swaylock -i '~/.lockbg' -s fill -c '282a36'"
#Switch the comments below to use rofi instead of wofi
#logouthelper = "rofi -show power"
logouthelper = "/home/yayoi/.config/wofi/power.sh"
webbrowser = "qutebrowser"

@lazy.layout.function
def add_treetab_section(layout):
    prompt = qtile.widgets_map["prompt"]
    prompt.start_input("Section name", layout.cmd_add_section)

keys = [

    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "space", lazy.layout.next(), desc="Move window focus to other window"),

    Key([mod, "shift"], "h",
        lazy.layout.shuffle_left(),
        lazy.layout.move_left().when(layout=["treetab"]),
        desc="Move window to the left/move tab left in treetab"),

    Key([mod, "shift"], "l",
        lazy.layout.shuffle_right(),
        lazy.layout.move_right().when(layout=["treetab"]),
        desc="Move window to the right/move tab right in treetab"),

    Key([mod, "shift"], "j",
        lazy.layout.shuffle_down(),
        lazy.layout.section_down().when(layout=["treetab"]),
        desc="Move window down/move down a section in treetab"
    ),
    Key([mod, "shift"], "k",
        lazy.layout.shuffle_up(),
        lazy.layout.section_up().when(layout=["treetab"]),
        desc="Move window downup/move up a section in treetab"
    ),

    Key([mod, "shift"], "a", add_treetab_section, desc='Prompt to add new section in treetab'),

    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key([mod, "control"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key([mod, "control"], "l", lazy.layout.grow_right(), desc="Grow window to the right"),
    Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key(
        [mod, "shift"],
        "Return",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack",
    ),
# Grow/shrink windows left/right.
    # This is mainly for the 'monadtall' and 'monadwide' layouts
    # although it does also work in the 'bsp' and 'columns' layouts.
    Key([mod], "equal",
        lazy.layout.grow_left().when(layout=["bsp", "columns"]),
        lazy.layout.grow().when(layout=["monadtall", "monadwide"]),
        desc="Grow window to the left"
    ),
    Key([mod], "minus",
        lazy.layout.grow_right().when(layout=["bsp", "columns"]),
        lazy.layout.shrink().when(layout=["monadtall", "monadwide"]),
        desc="Grow window to the left"
    ),

    Key([mod], "Return", lazy.spawn("wofi --show drun"), desc="Run an app"),
    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "q", lazy.window.kill(), desc="Kill focused window"),
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "shift"], "q", lazy.spawn(logouthelper)),
    #Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key([mod, "control"], "q", lazy.spawn(screenlocker), desc="Lock the screen"),
    Key([mod], "r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),

    # Audio
    Key([], "XF86AudioPlay", lazy.spawn("mpc toggle")),
    Key([], "XF86AudioNext", lazy.spawn("mpc next")),
    Key([], "XF86AudioPrev", lazy.spawn("mpc prev")),
    Key([], "XF86AudioMute", lazy.widget["volume"].mute()),
    Key([], "XF86AudioLowerVolume", lazy.widget["volume"].decrease_vol()),
    Key([], "XF86AudioRaiseVolume", lazy.widget["volume"].increase_vol()),

    KeyChord([mod], "m", [
        Key([], "m", lazy.spawn(emacs + "--eval '(emms-browser)'")),
        Key([], "s", lazy.spawn("mpc stop"))
    ]),

    #Application shortcuts!
    KeyChord([mod], "a", [
        Key([], "e", lazy.spawn(editor), desc="Launch default text editor"),
        Key([], "m", lazy.spawn(mail), desc="Launch default mail/rss client"),
        Key([], "f", lazy.spawn(filemanager), desc="Launch default file manager"),
        Key([], "b", lazy.spawn(webbrowser), desc="Launch default web browser"),
        Key([], "t", lazy.spawn(terminal), desc="Launch the default terminal")
    ]),

    #Get various prompts
    KeyChord([mod], "p", [
        Key([], "p", lazy.spawn("wofi --show drun,run -p 'search'"), desc="Show a general prompt"),
        Key([], "r", lazy.spawn("wofi --show run"), desc="Show a more basic, demnu-like, run prompt"),
        Key([], "d", lazy.spawn("wofi --show drun"), desc="Show a more advanced application launcher prompt")
    ]),

    #Notification bindings
    KeyChord([mod], "n", [
        Key([], "p", lazy.widget["notify"].prev(), desc="Show previous notification"),
        Key([], "a", lazy.widget["notify"].invoke(), desc="Invoke notification's default action"),
        Key([], "c", lazy.widget["notify"].clear(), desc="Clear current notification")
    ])
]

groups = []
group_names = ["1","2","3","4","5"]
group_labels = ["1","2","3","4","5"]
# group_labels ["web","txt","misc","vid","msg"]
group_layouts = ["treetab","treetab","spiral","monadtall","monadwide"]

for i in range(len(group_names)):
    groups.append(
        Group(
            name=group_names[i],
            layout=group_layouts[i].lower(),
            label=group_labels[i],
        ))

for i in groups:
    keys.extend(
        [
            # mod1 + letter of group = switch to group
            Key(
                [mod],
                i.name,
                lazy.group[i.name].toscreen(),
                desc="Switch to group {}".format(i.name),
            ),
            # mod1 + shift + letter of group = switch to & move focused window to group
            Key(
                [mod, "shift"],
                i.name,
                lazy.window.togroup(i.name, switch_group=True),
                desc="Switch to & move focused window to group {}".format(i.name),
            ),
            # Or, use below if you prefer not to switch to that group.
            # # mod1 + shift + letter of group = move focused window to group
            # Key([mod, "shift"], i.name, lazy.window.togroup(i.name),
            #     desc="move focused window to group {}".format(i.name)),
        ]
    )

colors = colors.Dracula

layout_theme = {
    "border_width": 2,
    "margin": 6,
    "border_focus": "e1acff",
    "border_normal": "1D2330",
}

layouts = [
    # layout.Columns(**layout_theme),
    # Try more layouts by unleashing below layouts.
    layout.Spiral(main_pain="left",clockwise=True,**layout_theme),
    # layout.Stack(num_stacks=2,**layout_theme),
    # layout.Bsp(**layout_theme),
    # layout.Matrix(**layout_theme),
    layout.Tile(**layout_theme),
    layout.MonadWide(**layout_theme),
    layout.MonadTall(**layout_theme),
    # layout.RatioTile(**layout_theme),
    # layout.VerticalTile(**layout_theme),
    layout.TreeTab(
         font = "Noto Sans Bold",
         fontsize = 11,
         border_width = 0,
         bg_color = colors[0],
         active_bg = colors[8],
         active_fg = colors[2],
         inactive_bg = colors[1],
         inactive_fg = colors[0],
         padding_left = 8,
         padding_x = 8,
         padding_y = 6,
         sections = ["MAIN"],
         section_fontsize = 10,
         section_fg = colors[7],
         section_top = 15,
         section_bottom = 15,
         level_shift = 8,
         vspace = 3,
         panel_width = 240
         ),
    layout.Max()
]

widget_decor = {
    "decorations": [
        RectDecoration(colour=colors[8],radius=10,filled=True,group=True)
    ],
    "padding": 10,
}

msg_decor = {
    "decorations": [
        RectDecoration(colour=colors[2],radius=10,filled=True,group=True)
    ],
    "padding": 10,
}

name_decor = {
    "decorations": [
        RectDecoration(colour=colors[6],radius=10,filled=True,group=True)
    ],
    "padding": 10,
}

widget_defaults = dict(
    font="mononoki Nerd Font Bold",
    fontsize=12,
    padding=3,
)
extension_defaults = widget_defaults.copy()

screens = [
    Screen(
        wallpaper="~/.wallpaper",
        wallpaper_mode="fill",
        top=bar.Bar(
            [
                widget.CurrentLayoutIcon(padding=5),
                widget.GroupBox(highlight_color=colors[6],highlight_method="line",active=colors[1],inactive=colors[8],this_screen_border=colors[0],this_current_screen_border=colors[0]),
                #widget.CurrentLayout(foreground=colors[2]),
                widget.Spacer(length=10),
                widget.WindowName(font="Noto Sans bold",foreground=colors[0],empty_group_string="Desktop - Press '[CMD]+[RET]' to start",**name_decor),
                #widget.Prompt(),
                widget.Spacer(length=20),
                widget.Prompt(foreground=colors[1],**msg_decor),
                widget.CheckUpdates(foreground=colors[6],distro="Arch_yay",colour_have_updates=colors[4],colour_no_updates=colors[1],initial_text="updates (yay) checking...",**msg_decor),
                widget.Notify(foreground=colors[4], foreground_low=colors[1],foreground_urgent=colors[3],**msg_decor),
                widget.Spacer(length=20),
                widget.Mpd2(foreground=colors[0],status_format="{play_status} {title}",idle_format="{play_status} {idle_message}",idle_message="Not Playing",**widget_decor),
                widget.Volume(fmt="Vol: {}",foreground=colors[0],**widget_decor),
                # NB Systray is incompatible with Wayland, consider using StatusNotifier instead
                #widget.Systray(),
                widget.StatusNotifier(icon_theme="Dracula",**widget_decor),
                widget.Clock(format="%a, %d %b %Y %I:%M %p",foreground=colors[0],**widget_decor),
                widget.Spacer(length=10),
            ],
            28,
            background=colors[0],
            opacity=0.96,
            # border_width=[2, 0, 2, 0],  # Draw top and bottom borders
            # border_color=["ff00ff", "000000", "ff00ff", "000000"]  # Borders are magenta
        ),
    ),
]

mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ]
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None

os.environ["QT_QPA_PLATFORMTHEME"] = "qt5ct"

@hook.subscribe.startup_once
def start_once():
    home = os.path.expanduser('~')
    subprocess.call([home + '/.config/qtile/autostart.sh'])

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
