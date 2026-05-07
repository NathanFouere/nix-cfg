{
  pkgs,
  ...
}:

{

  home = {
    username = "admin";
    stateVersion = "25.11";
  };

  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    wget
    git
    sshpass
    mkcert
    unzip
    htop
    util-linux
    lsof
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
