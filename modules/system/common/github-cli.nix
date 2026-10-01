{
  pkgs,
  config,
  ...
}:
{
  environment.systemPackages = [ pkgs.gh ];

  age.secrets.github-token = {
    file = ../../../secrets/github-token.age;
  };

  # Rend le token disponible dans tous les shell
  environment.extraInit = ''
    export GH_TOKEN="$(cat ${config.age.secrets.github-token.path} 2>/dev/null)"
  '';

  # cf . https://cli.github.com/manual/gh_auth_login
  environment.etc.gitconfig.text = ''
    [credential "https://github.com"]
      helper = !${pkgs.gh}/bin/gh auth git-credential
    [credential "https://gist.github.com"]
      helper = !${pkgs.gh}/bin/gh auth git-credential
  '';
}
