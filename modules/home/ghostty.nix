{
  ...
}:

{
  programs.ghostty = {
    enable = true;

    settings = {
      font-size = 12;

      window-padding-x = 14;
      window-padding-y = 10;
      window-padding-balance = true;
      window-decoration = false;
      cursor-style = "bar";
      cursor-style-blink = true;

      confirm-close-surface = false;

      shell-integration = "zsh";
      # sudo : garde le terminfo ghostty sous sudo
      # ssh-* : installe le terminfo sur les machines distantes (sinon TERM inconnu sur les serveurs)
      shell-integration-features = "sudo,ssh-env,ssh-terminfo";

      keybind = [
        "ctrl+shift+d=new_split:right"
        "ctrl+shift+s=new_split:down"

        "ctrl+shift+h=goto_split:left"
        "ctrl+shift+j=goto_split:down"
        "ctrl+shift+k=goto_split:up"
        "ctrl+shift+l=goto_split:right"

        "ctrl+alt+shift+arrow_left=resize_split:left,10"
        "ctrl+alt+shift+arrow_down=resize_split:down,10"
        "ctrl+alt+shift+arrow_up=resize_split:up,10"
        "ctrl+alt+shift+arrow_right=resize_split:right,10"

        "ctrl+shift+z=toggle_split_zoom"
      ];
    };
  };
}
