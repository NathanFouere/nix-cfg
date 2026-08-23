{
  config,
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [
    xwayland-satellite
    playerctl
  ];

  programs.niri.settings =
    let
      # Base keybinds adapted from niri's default config (pinned v26.04):
      # https://github.com/niri-wm/niri/blob/v26.04/resources/default-config.kdl
      # Noctalia IPC binds from: https://docs.noctalia.dev/noctalia/compositor-settings/niri/
      default-binds = {
        # Mod-Shift-/, usually the same as Mod-?, shows a list of important hotkeys
        "Mod+Shift+Slash".action.show-hotkey-overlay = [ ];

        "Mod+T".hotkey-overlay.title = "Open a Terminal: ghostty";
        "Mod+T".action.spawn = "ghostty";
        "Mod+D".hotkey-overlay.title = "Run an Application: noctalia launcher";
        "Mod+D".action.spawn-sh = "noctalia msg panel-toggle launcher";
        "Mod+Space".action.spawn-sh = "noctalia msg panel-toggle launcher";
        "Mod+S".action.spawn-sh = "noctalia msg panel-toggle control-center";
        "Alt+Tab".action.spawn-sh = "noctalia msg window-switcher";
        "Super+Alt+L".hotkey-overlay.title = "Lock the Screen: noctalia";
        "Super+Alt+L".action.spawn-sh = "noctalia msg session lock";

        # Volume keys via noctalia (with OSD)
        "XF86AudioRaiseVolume".allow-when-locked = true;
        "XF86AudioRaiseVolume".action.spawn-sh = "noctalia msg volume-up";
        "XF86AudioLowerVolume".allow-when-locked = true;
        "XF86AudioLowerVolume".action.spawn-sh = "noctalia msg volume-down";
        "XF86AudioMute".allow-when-locked = true;
        "XF86AudioMute".action.spawn-sh = "noctalia msg volume-mute";
        "XF86AudioMicMute".allow-when-locked = true;
        "XF86AudioMicMute".action.spawn-sh = "noctalia msg mic-mute";

        # Media keys
        "XF86AudioPlay".allow-when-locked = true;
        "XF86AudioPlay".action.spawn-sh = "playerctl play-pause";
        "XF86AudioStop".allow-when-locked = true;
        "XF86AudioStop".action.spawn-sh = "playerctl stop";
        "XF86AudioPrev".allow-when-locked = true;
        "XF86AudioPrev".action.spawn-sh = "playerctl previous";
        "XF86AudioNext".allow-when-locked = true;
        "XF86AudioNext".action.spawn-sh = "playerctl next";

        # Brightness keys via noctalia (with OSD)
        "XF86MonBrightnessUp".allow-when-locked = true;
        "XF86MonBrightnessUp".action.spawn-sh = "noctalia msg brightness-up";
        "XF86MonBrightnessDown".allow-when-locked = true;
        "XF86MonBrightnessDown".action.spawn-sh = "noctalia msg brightness-down";

        # Overview: zoomed-out view of workspaces and windows
        "Mod+O".repeat = false;
        "Mod+O".action.toggle-overview = [ ];

        "Mod+Q".repeat = false;
        "Mod+Q".action.close-window = [ ];

        "Mod+Left".action.focus-column-left = [ ];
        "Mod+Down".action.focus-window-down = [ ];
        "Mod+Up".action.focus-window-up = [ ];
        "Mod+Right".action.focus-column-right = [ ];
        "Mod+H".action.focus-column-left = [ ];
        "Mod+J".action.focus-window-down = [ ];
        "Mod+K".action.focus-window-up = [ ];
        "Mod+L".action.focus-column-right = [ ];

        "Mod+Ctrl+Left".action.move-column-left = [ ];
        "Mod+Ctrl+Down".action.move-window-down = [ ];
        "Mod+Ctrl+Up".action.move-window-up = [ ];
        "Mod+Ctrl+Right".action.move-column-right = [ ];
        "Mod+Ctrl+H".action.move-column-left = [ ];
        "Mod+Ctrl+J".action.move-window-down = [ ];
        "Mod+Ctrl+K".action.move-window-up = [ ];
        "Mod+Ctrl+L".action.move-column-right = [ ];

        "Mod+Home".action.focus-column-first = [ ];
        "Mod+End".action.focus-column-last = [ ];
        "Mod+Ctrl+Home".action.move-column-to-first = [ ];
        "Mod+Ctrl+End".action.move-column-to-last = [ ];

        "Mod+Shift+Left".action.focus-monitor-left = [ ];
        "Mod+Shift+Down".action.focus-monitor-down = [ ];
        "Mod+Shift+Up".action.focus-monitor-up = [ ];
        "Mod+Shift+Right".action.focus-monitor-right = [ ];
        "Mod+Shift+H".action.focus-monitor-left = [ ];
        "Mod+Shift+J".action.focus-monitor-down = [ ];
        "Mod+Shift+K".action.focus-monitor-up = [ ];
        "Mod+Shift+L".action.focus-monitor-right = [ ];

        "Mod+Shift+Ctrl+Left".action.move-column-to-monitor-left = [ ];
        "Mod+Shift+Ctrl+Down".action.move-column-to-monitor-down = [ ];
        "Mod+Shift+Ctrl+Up".action.move-column-to-monitor-up = [ ];
        "Mod+Shift+Ctrl+Right".action.move-column-to-monitor-right = [ ];
        "Mod+Shift+Ctrl+H".action.move-column-to-monitor-left = [ ];
        "Mod+Shift+Ctrl+J".action.move-column-to-monitor-down = [ ];
        "Mod+Shift+Ctrl+K".action.move-column-to-monitor-up = [ ];
        "Mod+Shift+Ctrl+L".action.move-column-to-monitor-right = [ ];

        "Mod+Page_Down".action.focus-workspace-down = [ ];
        "Mod+Page_Up".action.focus-workspace-up = [ ];
        "Mod+U".action.focus-workspace-down = [ ];
        "Mod+I".action.focus-workspace-up = [ ];
        "Mod+Ctrl+Page_Down".action.move-column-to-workspace-down = [ ];
        "Mod+Ctrl+Page_Up".action.move-column-to-workspace-up = [ ];
        "Mod+Ctrl+U".action.move-column-to-workspace-down = [ ];
        "Mod+Ctrl+I".action.move-column-to-workspace-up = [ ];

        "Mod+Shift+Page_Down".action.move-workspace-down = [ ];
        "Mod+Shift+Page_Up".action.move-workspace-up = [ ];
        "Mod+Shift+U".action.move-workspace-down = [ ];
        "Mod+Shift+I".action.move-workspace-up = [ ];

        # Mouse wheel scroll ticks
        "Mod+WheelScrollDown".cooldown-ms = 150;
        "Mod+WheelScrollDown".action.focus-workspace-down = [ ];
        "Mod+WheelScrollUp".cooldown-ms = 150;
        "Mod+WheelScrollUp".action.focus-workspace-up = [ ];
        "Mod+Ctrl+WheelScrollDown".cooldown-ms = 150;
        "Mod+Ctrl+WheelScrollDown".action.move-column-to-workspace-down = [ ];
        "Mod+Ctrl+WheelScrollUp".cooldown-ms = 150;
        "Mod+Ctrl+WheelScrollUp".action.move-column-to-workspace-up = [ ];

        "Mod+WheelScrollRight".action.focus-column-right = [ ];
        "Mod+WheelScrollLeft".action.focus-column-left = [ ];
        "Mod+Ctrl+WheelScrollRight".action.move-column-right = [ ];
        "Mod+Ctrl+WheelScrollLeft".action.move-column-left = [ ];

        "Mod+Shift+WheelScrollDown".action.focus-column-right = [ ];
        "Mod+Shift+WheelScrollUp".action.focus-column-left = [ ];
        "Mod+Ctrl+Shift+WheelScrollDown".action.move-column-right = [ ];
        "Mod+Ctrl+Shift+WheelScrollUp".action.move-column-left = [ ];

        # Workspaces by index
        "Mod+1".action.focus-workspace = 1;
        "Mod+2".action.focus-workspace = 2;
        "Mod+3".action.focus-workspace = 3;
        "Mod+4".action.focus-workspace = 4;
        "Mod+5".action.focus-workspace = 5;
        "Mod+6".action.focus-workspace = 6;
        "Mod+7".action.focus-workspace = 7;
        "Mod+8".action.focus-workspace = 8;
        "Mod+9".action.focus-workspace = 9;
        "Mod+Ctrl+1".action.move-column-to-workspace = 1;
        "Mod+Ctrl+2".action.move-column-to-workspace = 2;
        "Mod+Ctrl+3".action.move-column-to-workspace = 3;
        "Mod+Ctrl+4".action.move-column-to-workspace = 4;
        "Mod+Ctrl+5".action.move-column-to-workspace = 5;
        "Mod+Ctrl+6".action.move-column-to-workspace = 6;
        "Mod+Ctrl+7".action.move-column-to-workspace = 7;
        "Mod+Ctrl+8".action.move-column-to-workspace = 8;
        "Mod+Ctrl+9".action.move-column-to-workspace = 9;

        # Move the focused window in and out of a column
        "Mod+BracketLeft".action.consume-or-expel-window-left = [ ];
        "Mod+BracketRight".action.consume-or-expel-window-right = [ ];
        "Mod+Comma".action.consume-window-into-column = [ ];
        "Mod+Period".action.expel-window-from-column = [ ];

        # Width presets
        "Mod+R".action.switch-preset-column-width = [ ];
        "Mod+Shift+R".action.switch-preset-column-width-back = [ ];
        "Mod+Ctrl+Shift+R".action.switch-preset-window-height = [ ];
        "Mod+Ctrl+R".action.reset-window-height = [ ];

        "Mod+F".action.maximize-column = [ ];
        "Mod+Shift+F".action.fullscreen-window = [ ];
        "Mod+M".action.maximize-window-to-edges = [ ];
        "Mod+Ctrl+F".action.expand-column-to-available-width = [ ];

        "Mod+C".action.center-column = [ ];
        "Mod+Ctrl+C".action.center-visible-columns = [ ];

        # Finer width/height adjustments
        "Mod+Minus".action.set-column-width = "-10%";
        "Mod+Equal".action.set-column-width = "+10%";
        "Mod+Shift+Minus".action.set-window-height = "-10%";
        "Mod+Shift+Equal".action.set-window-height = "+10%";

        # Floating / tiling
        "Mod+V".action.toggle-window-floating = [ ];
        "Mod+Shift+V".action.switch-focus-between-floating-and-tiling = [ ];

        # Tabbed column display mode
        "Mod+W".action.toggle-column-tabbed-display = [ ];

        "Print".action.screenshot = [ ];
        "Ctrl+Print".action.screenshot-screen = [ ];
        "Alt+Print".action.screenshot-window = [ ];

        # Escape hatch against buggy keyboard shortcut inhibitors
        "Mod+Escape".allow-inhibiting = false;
        "Mod+Escape".action.toggle-keyboard-shortcuts-inhibit = [ ];

        "Mod+Shift+E".action.quit = [ ];
        "Ctrl+Alt+Delete".action.quit = [ ];

        "Mod+Shift+P".action.power-off-monitors = [ ];
      };
    in
    {
      input.keyboard.xkb = {
        layout = "fr";
        variant = "azerty";
      };

      # Electron/Wayland: vscode, discord, element...
      environment = {
        NIXOS_OZONE_WL = "1";
        ELECTRON_OZONE_PLATFORM_HINT = "auto";
      };

      # Xwayland (X11 apps), spawned automatically by niri if in PATH
      xwayland-satellite.enable = true;

      spawn-at-startup = [
        { argv = [ "noctalia" ]; }
      ];

      # Noctalia integration (https://docs.noctalia.dev/noctalia/compositor-settings/niri/)
      # Wallpaper & backdrop (https://docs.noctalia.dev/noctalia/desktop/wallpaper/)
      window-rules = [
        {
          geometry-corner-radius = {
            top-left = 20.0;
            top-right = 20.0;
            bottom-left = 20.0;
            bottom-right = 20.0;
          };
          clip-to-geometry = true;
        }
        {
          matches = [ { app-id = "dev.noctalia.Noctalia"; } ];
          open-floating = true;
          default-column-width.fixed = 1080;
          default-window-height.fixed = 920;
        }
      ];

      layer-rules = [
        {
          matches = [ { namespace = "^noctalia-backdrop"; } ];
          place-within-backdrop = true;
        }
      ];

      # Allows notification actions and window activation from Noctalia
      debug.honor-xdg-activation-with-invalid-serial = true;

      binds = default-binds;
    };
}
