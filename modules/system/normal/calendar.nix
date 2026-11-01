{
  ...
}:
{
  age.secrets = {
    # Lu par Noctalia via password_file
    baikal-password = {
      file = ../../../secrets/baikal-password.age;
      owner = "nathanf";
    };
    # Compte CalDAV, fusionné avec config.toml (cf. https://docs.noctalia.dev/noctalia/configuration/)
    # Contenu déchiffré :
    #   [calendar.account.baikal]
    #   type = "caldav"
    #   name = "Baïkal"
    #   provider = "custom"
    #   server_url = "https://baikal.nathan-fouere.com/dav.php/"
    #   username = "..."
    #   credential_source = "file"
    #   password_file = "/run/agenix/baikal-password"
    noctalia-calendar-account = {
      file = ../../../secrets/noctalia-calendar-account.age;
      path = "/home/nathanf/.config/noctalia/calendar-account.toml";
      owner = "nathanf";
    };
  };
}
