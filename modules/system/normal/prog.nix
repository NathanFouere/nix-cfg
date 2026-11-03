{
  pkgs,
  ...
}:
{
  config = {
    # TODO : zotero embarque Firefox ESR 140 (EOL 2026-10-13) — à retirer quand nixpkgs aura migré zotero
    nixpkgs.config.permittedInsecurePackages = [
      "firefox-esr-140-bin-unwrapped-140.17.0esr"
    ];

    environment.systemPackages = with pkgs; [
      javaPackages.compiler.temurin-bin.jre-25
      tlaplus-toolbox
      tlaplus18
      tlafmt
      tlaps
      texliveFull
      jetbrains.datagrip
      iperf3
      go
      gcc
      zotero
    ];
  };
}
