{
  pkgs,
  ...
}:
{
  config = {
    environment.systemPackages = with pkgs; [
      javaPackages.compiler.temurin-bin.jre-25
    ];
  };
}
