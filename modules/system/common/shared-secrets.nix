{
  ...
}:
{
  age = {
    secrets.k3s-token.file = ../../../secrets/k3s-token.age;
    secrets.tailscale-oauth-id.file = ../../../secrets/tailscale-oauth-id.age;
    secrets.tailscale-oauth-key.file = ../../../secrets/tailscale-oauth-key.age;
  };
}
