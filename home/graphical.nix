{ config, pkgs, lib, ... }:

let
  serif     = "FuraCode Nerd Font";
  sansSerif = "FuraCode Nerd Font";
  monospace = "FuraCode Nerd Font Mono";

  internalMonitor = "eDP-1";
  externalMonitor = "Ancor Communications Inc PA328 F7LMQS054477";
in
  with config.resources.base16.colors;
  {
    imports = [
      ./gtk.nix
    ];

    config = with lib; mkMerge [
      (rec {
        home.file.".themes" = xdg.configFile."themes";

        home.packages = with pkgs; [
          font-awesome-ttf
          mpv
        ] ++ (with config.resources.programs; [
          browser.package
          terminal.package
        ]);

        home.sessionVariables.BROWSER = config.resources.programs.browser.executable.path;

        programs.browserpass.enable = true;

        programs.zathura.enable = true;
        programs.zathura.options.completion-bg = base02;
        programs.zathura.options.completion-fg = base0C;
        programs.zathura.options.completion-highlight-bg = base0C;
        programs.zathura.options.completion-highlight-fg = base02;
        programs.zathura.options.default-bg = base00;
        programs.zathura.options.default-fg = base01;
        programs.zathura.options.highlight-active-color = base0D;
        programs.zathura.options.highlight-color = base0A;
        programs.zathura.options.index-active-bg = base0D;
        programs.zathura.options.inputbar-bg = base00;
        programs.zathura.options.inputbar-fg = base05;
        programs.zathura.options.notification-bg = base0B;
        programs.zathura.options.notification-error-bg = base08;
        programs.zathura.options.notification-error-fg = base00;
        programs.zathura.options.notification-fg = base00;
        programs.zathura.options.notification-warning-bg = base08;
        programs.zathura.options.notification-warning-fg = base00;
        programs.zathura.options.recolor = true;
        programs.zathura.options.recolor-darkcolor = base06;
        programs.zathura.options.recolor-keephue = true;
        programs.zathura.options.recolor-lightcolor = base00;
        programs.zathura.options.selection-clipboard = "clipboard";
        programs.zathura.options.statusbar-bg = base01;
        programs.zathura.options.statusbar-fg = base04;

        xdg.configFile."chromium/Default/User StyleSheets/devtools.css".source = ../dotfiles/chromium/devtools.css;

        # Colors based on https://github.com/kdrag0n/base16-kitty/blob/742d0326db469cae2b77ede3e10bedc323a41547/templates/default-256.mustache#L3-L42
        xdg.configFile."kitty/kitty.conf".text = ''
          background                  ${base00}
          foreground                  ${base05}
          selection_background        ${base05}
          selection_foreground        ${base00}
          url_color                   ${base04}
          cursor                      ${base05}
          active_border_color         ${base03}
          inactive_border_color       ${base01}
          active_tab_background       ${base00}
          active_tab_foreground       ${base05}
          inactive_tab_background     ${base01}
          inactive_tab_foreground     ${base04}

          color0                      ${base00}
          color1                      ${base08}
          color2                      ${base0B}
          color3                      ${base0A}
          color4                      ${base0D}
          color5                      ${base0E}
          color6                      ${base0C}
          color7                      ${base05}
          color8                      ${base03}
          color9                      ${base08}
          color10                     ${base0B}
          color11                     ${base0A}
          color12                     ${base0D}
          color13                     ${base0E}
          color14                     ${base0C}
          color15                     ${base05}
          color16                     ${base09}
          color17                     ${base0F}
          color18                     ${base01}
          color19                     ${base02}
          color20                     ${base04}
          color21                     ${base06}

          close_on_child_death        yes
          cursor_blink_interval       0
          cursor_shape                underline
          cursor_stop_blinking_after  0
          editor                      ${config.resources.programs.editor.executable.path}
          font_family                 ${monospace}
          font_size                   ${if pkgs.stdenv.isDarwin then "18.0" else "15.0"}
          hide_window_decorations     yes
          initial_window_height       800
          initial_window_width        1200
          scrollback_pager            ${pkgs.less}/bin/less --chop-long-lines --RAW-CONTROL-CHARS +INPUT_LINE_NUMBER
          tab_bar_edge                top
        '';
        xdg.configFile."mpv/config".text = ''
          alang=eng,en,rus,ru
        '';
        xdg.configFile."oomox/colors".source = ../dotfiles/oomox/colors;
        xdg.configFile."themes".source = ../dotfiles/themes;

        xresources.properties."*.background" = base00;
        xresources.properties."*.base00" = base00;
        xresources.properties."*.base01" = base01;
        xresources.properties."*.base02" = base02;
        xresources.properties."*.base03" = base03;
        xresources.properties."*.base04" = base04;
        xresources.properties."*.base05" = base05;
        xresources.properties."*.base06" = base06;
        xresources.properties."*.base07" = base07;
        xresources.properties."*.base08" = base08;
        xresources.properties."*.base09" = base09;
        xresources.properties."*.base0A" = base0A;
        xresources.properties."*.base0B" = base0B;
        xresources.properties."*.base0C" = base0C;
        xresources.properties."*.base0D" = base0D;
        xresources.properties."*.base0E" = base0E;
        xresources.properties."*.base0F" = base0F;
        xresources.properties."*.color0" = base00;
        xresources.properties."*.color1" = base08;
        xresources.properties."*.color2" = base0B;
        xresources.properties."*.color3" = base0A;
        xresources.properties."*.color4" = base0D;
        xresources.properties."*.color5" = base0E;
        xresources.properties."*.color6" = base0C;
        xresources.properties."*.color7" = base05;
        xresources.properties."*.color8" = base03;
        xresources.properties."*.color9" = base08;
        xresources.properties."*.color10" = base0B;
        xresources.properties."*.color11" = base0A;
        xresources.properties."*.color12" = base0D;
        xresources.properties."*.color13" = base0E;
        xresources.properties."*.color14" = base0C;
        xresources.properties."*.color15" = base07;
        xresources.properties."*.color16" = base09;
        xresources.properties."*.color17" = base0F;
        xresources.properties."*.color18" = base01;
        xresources.properties."*.color19" = base02;
        xresources.properties."*.color20" = base04;
        xresources.properties."*.color21" = base06;
        xresources.properties."*.cursorColor" = base05;
        xresources.properties."*.foreground" = base05;
        xresources.properties."rofi.auto-select" = false;
        xresources.properties."rofi.color-active" = [ base00 base0B base01 base03 base05 ];
        xresources.properties."rofi.color-normal" = [ base00 base04 base01 base03 base06 ];
        xresources.properties."rofi.color-urgent" = [ base00 base0F base01 base03 base06 ];
        xresources.properties."rofi.color-window" = [ base00 base01 ];
        xresources.properties."rofi.opacity" = 90;
        xresources.properties."ssh-askpass*background" = base00;
        xresources.properties."xscreensaver.logFile" = "/var/log/xscreensaver.log";
        xresources.properties."Xcursor.size" = 20;
        xresources.properties."Xft.antialias" = 1;
        xresources.properties."Xft.autohint" = 0;
        xresources.properties."Xft.hinting" = 1;
        xresources.properties."Xft.hintstyle" = "hintslight";
        xresources.properties."Xft.lcdfilter" = "lcddefault";
        xresources.properties."Xft.rgba" = "rgb";
      })

      (mkIf pkgs.stdenv.isDarwin {
        home.file.".chunkwmrc".executable = true;
        home.file.".chunkwmrc".text = ''
          #!${pkgs.bash}/bin/bash
          chunkc core::log_file stdout
          chunkc core::log_level warn
          chunkc core::plugin_dir /usr/local/opt/chunkwm/share/chunkwm/plugins
          chunkc core::hotload 0

          chunkc set bsp_optimal_ratio             1.618
          chunkc set bsp_spawn_left                1
          chunkc set bsp_split_mode                optimal
          chunkc set bsp_split_ratio               0.5
          chunkc set custom_bar_all_monitors       0
          chunkc set custom_bar_enabled            0
          chunkc set custom_bar_offset_bottom      0
          chunkc set custom_bar_offset_left        0
          chunkc set custom_bar_offset_right       0
          chunkc set custom_bar_offset_top         22
          chunkc set desktop_gap_step_size         5.0
          chunkc set desktop_padding_step_size     10.0
          chunkc set ffm_bypass_modifier           fn
          chunkc set ffm_standby_on_float          1
          chunkc set focused_border_color          0xff0f6288
          chunkc set focused_border_outline        0
          chunkc set focused_border_radius         0
          chunkc set focused_border_skip_floating  0
          chunkc set focused_border_skip_monocle   0
          chunkc set focused_border_width          5
          chunkc set global_desktop_mode           bsp
          chunkc set global_desktop_offset_bottom  3
          chunkc set global_desktop_offset_gap     2
          chunkc set global_desktop_offset_left    3
          chunkc set global_desktop_offset_right   3
          chunkc set global_desktop_offset_top     3
          chunkc set monitor_focus_cycle           1
          chunkc set mouse_follows_focus           intrinsic
          chunkc set mouse_motion_interval         35
          chunkc set mouse_move_window             \"cmd 1\"
          chunkc set mouse_resize_window           \"cmd 2\"
          chunkc set preselect_border_color        0xffd75f5f
          chunkc set preselect_border_outline      0
          chunkc set preselect_border_radius       0
          chunkc set preselect_border_width        5
          chunkc set window_fade_alpha             0.85
          chunkc set window_fade_duration          0.25
          chunkc set window_fade_inactive          0
          chunkc set window_float_next             0
          chunkc set window_float_topmost          0
          chunkc set window_focus_cycle            monitor
          chunkc set window_region_locked          1
          chunkc set window_use_cgs_move           0

          chunkc core::load border.so
          chunkc core::load tiling.so
          chunkc core::load ffm.so

          chunkc tiling::rule --owner Finder --name Copy --state float &
          chunkc tiling::rule --owner \"App Store\" --state float &
          chunkc tiling::rule --owner \"Calculator\" --state float &
        '';
      })

      (mkIf pkgs.stdenv.isLinux {
        home.packages = with pkgs; [
          clipman
          gnome3.dconf
          gnome3.glib_networking
          grim
          imv
          kanshi
          libnotify
          pavucontrol
          slurp
          spotify
          waybar
          wl-clipboard
          wofi
          ydotool
        ];

        home.keyboard.layout = "lv,ru";
        home.keyboard.options = [
          "grp:alt_space_toggle"
          "terminate:ctrl_alt_bksp"
          "eurosign:5"
          "caps:escape"
        ];

        home.sessionVariables._JAVA_AWT_WM_NONREPARENTING = "1";
        home.sessionVariables.ECORE_EVAS_ENGINE="wayland_egl";
        home.sessionVariables.ELM_ENGINE="wayland_egl";
        home.sessionVariables.MOZ_ENABLE_WAYLAND="1";
        home.sessionVariables.QT_QPA_PLATFORM="wayland-egl";
        home.sessionVariables.QT_WAYLAND_DISABLE_WINDOWDECORATION="1";
        home.sessionVariables.QT_WAYLAND_FORCE_DPI="physical";
        home.sessionVariables.SAL_USE_VCLPLUGIN="gtk3";
        home.sessionVariables.SDL_VIDEODRIVER="wayland";

        programs.firefox.enable = true;
        programs.firefox.extensions =  with pkgs.nur.repos.rycee.firefox-addons; [
          auto-tab-discard
          cookie-autodelete
          dark-night-mode
          gopass-bridge
          https-everywhere
          link-cleaner
          multi-account-containers
          octotree
          peertubeify
          privacy-badger
          reddit-enhancement-suite
          refined-github
          save-page-we
          stylus
          text-contrast-for-dark-themes
          transparent-standalone-image
          ublock-origin
          vim-vixen
        ];
        programs.firefox.package = with pkgs; wrapFirefox.override {
          config = lib.setAttrByPath [ firefox.browserName or (builtins.parseDrvName firefox.name).name ] {
            enableBrowserpass = true;
            enableDjvu = true;
            enableGoogleTalkPlugin = true;
          };
        } firefox {};

        programs.mako.enable = true;
        programs.mako.backgroundColor = base00;
        programs.mako.borderColor = base0D;
        programs.mako.textColor = base05;
        programs.mako.font = "${monospace} 10";

        programs.zsh.loginExtra = ''
          if [ "$(${pkgs.busybox}/bin/tty)" = "/dev/tty1" ]; then
	        exec "${config.wayland.windowManager.sway.package}/bin/sway" &>! .sway.log
          fi
        '';

        services.redshift.enable = true;
        services.redshift.package = pkgs.redshift-wlr;
        services.redshift.provider = "manual";
        services.redshift.tray = true;

        wayland.windowManager.sway.enable = true;
        wayland.windowManager.sway.extraConfig = ''
          focus output "${externalMonitor}"
        '';

        xdg.configFile."kanshi/config".text = ''
          profile "home" {
              output "${internalMonitor}" position 0,1080
              output "${externalMonitor}" position 1920,0
          }

          profile "otg" {
              output "${internalMonitor}" 
          }
        '';

        # Based on https://github.com/Eluminae/base16-mako/blob/f46c99682c03d30f52436741f1902db36738bf06/templates/default.mustache#L6-L18
        xdg.configFile."mako/config".text = mkAfter ''
          [urgency=low]
          background-color=${base00}
          text-color=${base0A}
          border-color=${base0D}
          
          [urgency=high]
          background-color=${base00}
          text-color=${base08}
          border-color=${base0D}
        '';

        # TODO: Configure
        xdg.configFile."waybar/config".text = builtins.readFile "${pkgs.waybar}/etc/xdg/waybar/config";
        xdg.configFile."waybar/style.css".text = builtins.readFile "${pkgs.waybar}/etc/xdg/waybar/style.css";
      })
    ];
  }
