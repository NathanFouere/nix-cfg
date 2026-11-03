{
  ...
}:
{
  age.secrets = {
    # Mot de passe Zimbra (ou code d'application si 2FA), lu par Noctalia via password_file
    zimbra-password = {
      file = ../../../secrets/zimbra-password.age;
      owner = "nathanf";
    };
    # Compte CalDAV Zimbra, fusionné avec config.toml comme calendar-account.toml
    # Contenu déchiffré :
    #   [calendar.account.zimbra]
    #   type = "caldav"
    #   name = "IMT"
    #   provider = "custom"
    #   server_url = "https://z.imt.fr/dav/<email>/"
    #   username = "<email>"
    #   credential_source = "file"
    #   password_file = "/run/agenix/zimbra-password"
    noctalia-zimbra-account = {
      file = ../../../secrets/noctalia-zimbra-account.age;
      path = "/home/nathanf/.config/noctalia/zimbra-account.toml";
      owner = "nathanf";
    };
  };
}
