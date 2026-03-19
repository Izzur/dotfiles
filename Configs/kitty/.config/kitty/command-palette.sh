#!/bin/sh
# Kitty command palette - launched as an overlay via fzf

COMMANDS='Copy to clipboard	copy_to_clipboard
Paste from clipboard	paste_from_clipboard
Paste from selection	paste_from_selection
New window (current dir)	launch --cwd=current
New tab (current dir)	new_tab_with_cwd
Close window	close_window
Close tab	close_tab
Next tab	next_tab
Previous tab	previous_tab
Move tab forward	move_tab_forward
Move tab backward	move_tab_backward
Next window	next_window
Previous window	previous_window
Set tab title	set_tab_title
Scroll page up	scroll_page_up
Scroll page down	scroll_page_down
Scroll to top	scroll_home
Scroll to bottom	scroll_end
Show scrollback in pager	show_scrollback
Increase font size	change_font_size all +2.0
Decrease font size	change_font_size all -2.0
Reset font size	change_font_size all 0
Toggle fullscreen	toggle_fullscreen
Reload config	load_config_file
Edit config	launch --type=tab vim ~/.config/kitty/kitty.conf
Clear terminal	clear_terminal scrollback active
Reset terminal	clear_terminal reset active
Next layout	next_layout
Unicode input	kitten unicode_input
Open URL hints	kitten hints
Insert path hints	kitten hints --type path --program -
Insert line hints	kitten hints --type line --program -
Insert word hints	kitten hints --type word --program -
Split horizontal (top/bottom)	launch --location=hsplit --cwd=current
Split vertical (left/right)	launch --location=vsplit --cwd=current'

choice=$(echo "$COMMANDS" | fzf \
    --delimiter='	' \
    --with-nth=1 \
    --prompt='Command > ' \
    --layout=reverse \
    --border=rounded \
    --margin=1,2 \
    --no-info)

[ -z "$choice" ] && exit 0

action=$(echo "$choice" | cut -d'	' -f2)
# shellcheck disable=SC2086
kitten @ action $action
