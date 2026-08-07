{
  ...
}:

{
  age = {
    secrets.cloudflared-tunnel-cred.file = ../../../secrets/cloudflared-tunnel-cred.age;
    secrets.cloudflare-origin-key.file = ../../../secrets/cloudflare-origin-key.age;
    secrets.nodes-pswd.file = ../../../secrets/nodes-pswd.age;
    secrets.cloudflare-origin-cert-2.file = ../../../secrets/cloudflare-origin-cert-2.age;
  };
}
