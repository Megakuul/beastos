{ pkgs, ... }:
let
  geany-themes = pkgs.fetchFromGitHub {
    owner = "geany";
    repo = "geany-themes";
    rev = "08a7937cc92a6402b4dd66d15bfe4c74719c420c"; 
    sha256 = "sha256-IwtVTNZRV0IZeeDBvALfaNVrli7gNI/iTTIFZB5rUrU="; 
  };
in
{
  home.packages = with pkgs; [ geany-with-vte ];

  xdg.configFile."geany/geany.conf".text = ''
    [geany]
    color_scheme=darcula.conf
    pref_main_load_session=true
    pref_main_project_file_in_basedir=true
    pref_main_save_winpos=true
    pref_main_save_wingeom=true
    pref_main_confirm_exit=false
    pref_main_suppress_status_messages=false
    switch_msgwin_pages=false
    beep_on_errors=true
    auto_focus=false
    sidebar_symbol_visible=true
    sidebar_openfiles_visible=true
    editor_font=FiraCode Nerd Font Mono 12
    tagbar_font=FiraCode Nerd Font Propo weight=450 12
    msgwin_font=FiraCode Nerd Font Propo 12
    show_notebook_tabs=true
    show_tab_cross=true
    tab_order_ltr=true
    tab_order_beside=false
    tab_pos_editor=2
    tab_pos_msgwin=0
    tab_label_length=1000
    show_indent_guide=false
    show_white_space=false
    show_line_endings=false
    show_line_endings_only_when_differ=false
    show_markers_margin=true
    show_linenumber_margin=true
    long_line_enabled=true
    long_line_type=0
    long_line_column=72
    long_line_color=#C2EBC2
    symbolcompletion_max_height=10
    symbolcompletion_min_chars=4
    use_folding=true
    unfold_all_children=false
    use_indicators=true
    line_wrapping=false
    auto_close_xml_tags=true
    complete_snippets=true
    auto_complete_symbols=true
    pref_editor_disable_dnd=false
    pref_editor_smart_home_key=true
    pref_editor_newline_strip=false
    line_break_column=72
    auto_continue_multiline=true
    comment_toggle_mark=~ 
    scroll_stop_at_last_line=true
    autoclose_chars=0
    pref_editor_default_new_encoding=UTF-8
    pref_editor_default_open_encoding=none
    default_eol_character=2
    pref_editor_new_line=true
    pref_editor_ensure_convert_line_endings=false
    pref_editor_replace_tabs=false
    pref_editor_trail_space=false
    pref_toolbar_show=true
    pref_toolbar_append_to_menu=false
    pref_toolbar_use_gtk_default_style=true
    pref_toolbar_use_gtk_default_icon=true
    pref_toolbar_icon_style=0
    pref_toolbar_icon_size=0
    context_action_cmd=
    sidebar_visible=true
    statusbar_visible=true
    msgwindow_visible=true
    fullscreen=false
    symbols_group_by_type=true
    color_picker_palette=
    scribble_text=Type here what you want, use it as a notice/scratch board
    scribble_pos=57
    custom_date_format=
    default_open_path=
    cmdline_new_files=true
    notebook_double_click_hides_widgets=false
    tab_close_switch_to_mru=false
    tab_pos_sidebar=2
    openfiles_path_mode=2
    sidebar_pos=0
    symbols_sort_mode=0
    msgwin_orientation=1
    highlighting_invert_all=false
    pref_main_search_use_current_word=true
    check_detect_indent=false
    detect_indent_width=false
    use_tab_to_indent=true
    backspace_unindent=true
    pref_editor_tab_width=2
    indent_mode=2
    indent_type=1
    virtualspace=1
    change_history_markers=false
    change_history_indicators=false
    autocomplete_doc_words=false
    completion_drops_rest_of_word=false
    autocompletion_max_entries=30
    autocompletion_update_freq=250
    color_scheme=
    scroll_lines_around_cursor=0
    mru_length=10
    disk_check_timeout=30
    show_editor_scrollbars=true
    brace_match_ltgt=false
    use_gtk_word_boundaries=true
    complete_snippets_whilst_editing=false
    indent_hard_tab_width=8
    editor_ime_interaction=0
    use_atomic_file_saving=false
    gio_unsafe_save_backup=false
    use_gio_unsafe_file_saving=true
    keep_edit_history_on_reload=true
    show_keep_edit_history_on_reload_msg=true
    reload_clean_doc_on_file_change=false
    save_config_on_file_change=true
    extract_filetype_regex=-\\*-\\s*([^\\s]+)\\s*-\\*-
    allow_always_save=false
    find_selection_type=0
    replace_and_find_by_default=true
    show_symbol_list_expanders=true
    compiler_tab_autoscroll=true
    new_document_after_close=false
    msgwin_status_visible=true
    msgwin_compiler_visible=true
    msgwin_messages_visible=true
    msgwin_scribble_visible=true

    [tools]
    terminal_cmd=xterm -e "/bin/sh %c"
    browser_cmd=
    grep_cmd=rg

    [VTE]
    load_vte=true
    font=FiraCode Nerd Font Propo 11
    scroll_on_key=true
    scroll_on_out=true
    enable_bash_keys=true
    ignore_menu_bar_accel=false
    follow_path=false
    run_in_vte=false
    skip_run_script=false
    cursor_blinks=false
    scrollback_lines=500
    shell=/run/current-system/sw/bin/zsh
    colour_fore=#9A9996
    colour_back=#262323
    send_cmd_prefix=
    send_selection_unsafe=false

    [build-menu]
    number_ft_menu_items=0
    number_non_ft_menu_items=0
    number_exec_menu_items=0
  '';

  xdg.configFile."geany/colorschemes".source =
    "${geany-themes}/colorschemes";
}
