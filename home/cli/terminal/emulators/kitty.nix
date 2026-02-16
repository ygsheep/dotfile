{
  config,
  lib,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [kitty];

  xdg.configFile."kitty/kitty.conf".text = ''
    # Kitty 终端配置
    # Font configuration
    font_family      ZedMono Nerd Font Mono
    bold_font        auto
    italic_font      auto
    bold_italic_font auto
    font_size        14.0

    # Cursor
    cursor_shape     beam
    cursor_beam_thickness 2.0
    cursor_blink_interval     0.5
    cursor_stop_blinking_after 15.0

    # Scrollback
    scrollback_lines 10000
    scrollback_pager history --

    # Mouse
    mouse_hide_wait 3.0
    url_style curly
    open_url_with default

    # Performance
    repaint_delay 10
    input_delay 3
    sync_to_monitor yes

    # Bell
    enable_audio_bell no
    visual_bell_duration 0.0
    window_alert_on_bell yes
    bell_on_tab yes

    # Window layout
    remember_window_size  yes
    initial_window_width  640
    initial_window_height 400

    # New window working directory
    working_directory last  # 使用上一个窗口的目录

    # Tab bar
    tab_bar_edge bottom
    tab_bar_style fade
    tab_bar_min_tabs 2
    tab_switch_strategy previous
    tab_fade 0.25 0.5 0.75 1

    # Color scheme (Gruvbox Dark)
    foreground #ebdbb2
    background #1d2021
    background_opacity 0.98

    # Cursor colors
    cursor #ebdbb2
    cursor_text_color #1d2021

    # URL underline color when hovering with mouse
    url_color #d65d0e

    # Terminal window title
    tab_title_template "{index}: {title}"
    active_tab_title_template none

    # Selection
    selection_foreground #1d2021
    selection_background #ebdbb2

    # Black
    color0 #282828
    color8 #928374

    # Red
    color1 #cc241d
    color9 #fb4934

    # Green
    color2  #98971a
    color10 #b8bb26

    # Yellow
    color3  #d79921
    color11 #fabd2f

    # Blue
    color4  #458588
    color12 #83a598

    # Magenta
    color5  #b16286
    color13 #d3869b

    # Cyan
    color6  #689d6a
    color14 #8ec07c

    # White
    color7  #a89984
    color15 #ebdbb2

    # Shell integration
    shell_integration enabled

    # Keyboard shortcuts
    kitty_mod ctrl+shift

    # Clipboard operations
    map kitty_mod+c copy_to_clipboard
    map kitty_mod+v paste_from_clipboard
    map kitty_mod>s paste_from_selection

    # Scrolling
    map kitty_mod+up scroll_line_up
    map kitty_mod+down scroll_line_down
    map kitty_mod+page_up scroll_page_up
    map kitty_mod+page_down scroll_page_down
    map kitty_mod+home scroll_home
    map kitty_mod+end scroll_end
    map kitty_mod+h show_scrollback

    # Window management
    map kitty_mod+enter new_window
    map kitty_mod+n new_os_window
    map kitty_mod+w close_window
    map kitty_mod+] next_window
    map kitty_mod+[ previous_window
    map kitty_mod+f move_window_forward
    map kitty_mod+b move_window_backward
    map kitty_mod+r start_resizing_window
    map kitty_mod+1 first_window
    map kitty_mod+2 second_window
    map kitty_mod+3 third_window
    map kitty_mod+4 fourth_window
    map kitty_mod+5 fifth_window
    map kitty_mod+6 sixth_window
    map kitty_mod+7 seventh_window
    map kitty_mod+8 eighth_window
    map kitty_mod+9 ninth_window
    map kitty_mod+0 tenth_window

    # Tab management
    map kitty_mod+t new_tab
    map kitty_mod+q close_tab
    map kitty_mod+. next_tab
    map kitty_mod+, previous_tab
    map kitty_mod+alt+t move_tab_forward
    map kitty_mod+alt+, move_tab_backward

    # Layout management
    map kitty_mod+l next_layout
  '';

  # Optional: Create a theme file that can be sourced
  xdg.configFile."kitty/theme.conf".text = ''
    # Gruvbox Dark Hard Theme
    foreground #ebdbb2
    background #1d2021
    background_opacity 0.95
    cursor #ebdbb2
    url_color #d65d0e
    selection_foreground #1d2021
    selection_background #ebdbb2
  '';
}
