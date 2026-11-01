{
  ...
}:

{
  age = {
    secrets.cloudflared-tunnel-cred.file = ../../../secrets/cloudflared-tunnel-cred.age;
    secrets.nodes-pswd.file = ../../../secrets/nodes-pswd.age;
    secrets.traefik-dashboard-pswd.file = ../../../secrets/traefik-dashboard-pswd.age;
  };
}
