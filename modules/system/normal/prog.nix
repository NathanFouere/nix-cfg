{
  pkgs,
  ...
}:
{
  config = {
    environment.systemPackages = with pkgs; [
      javaPackages.compiler.temurin-bin.jre-25
      tlaplus-toolbox
      tlaplus18
      tlafmt
      tlaps
      texliveFull
      jetbrains.datagrip
    ];
  };
}
