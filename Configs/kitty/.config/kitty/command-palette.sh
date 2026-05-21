#!/bin/sh
# Kitty command palette - launched as an overlay via fzf

# Format: Label<tab>action<tab>shortcut hint
COMMANDS='Split horizontal (left/right)	launch --location=hsplit --cwd=current
Split vertical (top/bottom)	launch --location=vsplit --cwd=current
Copy to clipboard	copy_to_clipboard	ctrl+shift+c
Paste from clipboard	paste_from_clipboard	ctrl+shift+v
Paste from selection	paste_from_selection	ctrl+shift+s
New window (current dir)	launch --cwd=current	ctrl+shift+enter
New tab (current dir)	new_tab_with_cwd	ctrl+shift+t
Close window	close_window	ctrl+shift+w
Close tab	close_tab	ctrl+shift+q
Next tab	next_tab	ctrl+shift+right
Previous tab	previous_tab	ctrl+shift+left
Move tab forward	move_tab_forward	ctrl+shift+.
Move tab backward	move_tab_backward	ctrl+shift+,
Next window	next_window
Previous window	previous_window
Set tab title	set_tab_title	ctrl+shift+alt+t
Scroll page up	scroll_page_up	ctrl+shift+pgup
Scroll page down	scroll_page_down	ctrl+shift+pgdn
Scroll to top	scroll_home	ctrl+shift+home
Scroll to bottom	scroll_end	ctrl+shift+end
Show scrollback in pager	show_scrollback	ctrl+shift+h
Increase font size	change_font_size all +2.0	ctrl+shift+=
Decrease font size	change_font_size all -2.0	ctrl+shift+-
Reset font size	change_font_size all 0	ctrl+shift+backspace
Toggle fullscreen	toggle_fullscreen	ctrl+shift+f11
Reload config	load_config_file	ctrl+shift+f5
Edit config	launch --type=tab vim ~/.config/kitty/kitty.conf	ctrl+shift+f2
Clear terminal	clear_terminal scrollback active
Reset terminal	clear_terminal reset active
Next layout	next_layout	ctrl+shift+l
Unicode input	kitten unicode_input	ctrl+shift+u
Open URL hints	kitten hints	ctrl+shift+e
Insert path hints	kitten hints --type path --program -
Insert line hints	kitten hints --type line --program -
Insert word hints	kitten hints --type word --program -	'

# Build display: pad label and right-align shortcut
display=$(echo "$COMMANDS" | awk -F'\t' '{
    label = $1
    shortcut = $3
    if (shortcut != "")
        printf "%-40s %s\n", label, shortcut
    else
        printf "%s\n", label
}')

# Use line number to map back to the original command
chosen_line=$(echo "$display" | fzf \
    --prompt='Command > ' \
    --layout=reverse \
    --border=rounded \
    --margin=1,2 \
    --no-info)

[ -z "$chosen_line" ] && exit 0

# Match the chosen display line back to the command
line_num=$(echo "$display" | grep -nxF "$chosen_line" | head -1 | cut -d: -f1)
action=$(echo "$COMMANDS" | sed -n "${line_num}p" | cut -d'	' -f2)

# shellcheck disable=SC2086
kitten @ action $action
