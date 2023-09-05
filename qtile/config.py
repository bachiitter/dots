import os
import subprocess

from libqtile import bar, hook, layout
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.dgroups import simple_key_binder
from libqtile.lazy import lazy
from theme import grayscale

myFont = "Ubuntu Bold"
myTerminal = "alacritty"
mod = "mod4"

widget_defaults = dict(
    font=myFont,
    fontsize=11,
    padding=5,
    foreground=grayscale["foreground"]
)

decor = {
    "borderwidth": 3,
    "highlight_method": "line",
    "margin_y": 4,
    "margin_x": 0,
    "padding_y": 3,
    "padding_x": 5,
    "rounded": False,
    "inactive": grayscale['white'],
    "active": grayscale["blue"],
    "highlight_color": grayscale["yellow"],
    "this_current_screen_border": grayscale["red"],
    "block_hightlight_text_color": grayscale["red"],
    "background": grayscale["background"],
    "foreground": grayscale["foreground"],
    "font": "Font Awesome 6 Free Solid",
}

keys = [
    # Switch between windows
    Key([mod], "h", lazy.layout.left()),
    Key([mod], "l", lazy.layout.right()),
    Key([mod], "j", lazy.layout.down()),
    Key([mod], "k", lazy.layout.up()),
    # Move window between different coloumns
    Key([mod, "shift"], "h", lazy.layout.shuffle_left()),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right()),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down()),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up()),
    # Change window size
    Key([mod, "control"], "h", lazy.layout.grow_left()),
    Key([mod, "control"], "l", lazy.layout.grow_right()),
    Key([mod, "control"], "j", lazy.layout.grow_down()),
    Key([mod, "control"], "k", lazy.layout.grow_up()),
    # Launch terminal
    Key([mod], "Return", lazy.spawn(myTerminal)),
    # Toggle layouts
    Key([mod], "Tab", lazy.next_layout()),
    # Close focused window
    Key([mod, "shift"], "c", lazy.window.kill()),
    # Reload qtile config
    Key([mod, "shift"], "r", lazy.reload_config()),
    # Restart qtile
    Key([mod, "shift"], "e", lazy.restart()),
    # Launch rofi
    Key([mod, "shift"], "Return", lazy.spawn(
        "rofi -show drun")),
    # Take screenshot(Scrot)
    Key([mod], "Print", lazy.spawn("flameshot full")),
    Key([], "Print", lazy.spawn("flameshot gui")),
    Key(
        [], "XF86AudioRaiseVolume",
        lazy.spawn("amixer -c 0 -q set Master 2dB+")
    ),
    Key(
        [], "XF86AudioLowerVolume",
        lazy.spawn("amixer -c 0 -q set Master 2dB-")
    ),
    Key(
        [], "XF86AudioMute",
        lazy.spawn("amixer -c 0 -q set Master toggle")
    ),
]

groups = [
    Group("", layout='monadtall'),
    Group("", layout='max'),
    Group("", layout='monadtall'),
    Group("", layout='columns'),
    Group("", layout="monadtall"),
]

dgroups_key_binder = simple_key_binder("mod4")

layouts = [
    layout.MonadTall(border_focus=grayscale["blue"],
                     border_normal=grayscale["background"],
                     margin=0,
                     border_width=3,
                     border_on_single=True
                     ),
    layout.Max(),
    layout.Columns(border_focus=grayscale["blue"],
                    border_normal=grayscale["background"],
                    margin=0,
                    border_width=3,
                    border_on_single=True
                   )
]

extension_defaults = widget_defaults.copy()

screens = [
    Screen(
        wallpaper="~/dots/qtile/grayscale.jpg",
        wallpaper_mode="fill",
        top=bar.Gap(0),
        bottom=bar.Gap(0),
        left=bar.Gap(0),
        right=bar.Gap(0)
    )
]

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(),
         start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_app_rules = []
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(
    float_rules=[
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ],
    border_focus=grayscale["cyan"],
    border_normal=grayscale["background"],
    margin=0,
    border_width=0,
    border_on_single=False
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True
auto_minimize = True
wl_input_rules = None
wmname = "Qtile"

@hook.subscribe.startup_once
def autostart():
    home = os.path.expanduser('~/.config/qtile/autostart.sh')
    subprocess.call([home])
