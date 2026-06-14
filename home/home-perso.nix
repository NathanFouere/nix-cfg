{
  pkgs,
  ...
}:

{

  home = {
    username = "nathanf";
    homeDirectory = "/home/nathanf";
    stateVersion = "24.11";
  };

  imports = [
    ../modules/home/zed.nix
    ../modules/home/ghostty.nix
    ../modules/home/ai.nix
  ];

  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    wget
    git
    sshpass
    mkcert
    unzip
    htop
    lazygit
    util-linux
    lsof
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
