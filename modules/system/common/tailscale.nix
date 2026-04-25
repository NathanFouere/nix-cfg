{ pkgs, config, ... }:
{
  services.tailscale = {
    enable = true;
    authKeyFile = "/var/lib/tailscale/dynamic-authkey";
  };

  # Ici on récupère le token api, puis on récupere le auth token, et on place le resultats dans "/var/lib/tailscale/dynamic-authkey""
  # cf . https://medium.com/@brent.gruber77/how-i-built-a-tailscale-auth-key-rotator-814722b839e0
  # cf . https://jqlang.org/
  # cf . https://techoverflow.net/2026/01/03/how-to-restart-a-systemd-service-weekly-using-systemd-timers/
  systemd.services.generate-n-store-tailscale-auth-token = {
    description = "Generate Tailscale auth key via OAuth";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    before = [ "tailscaled.service" ];
    wantedBy = [ "tailscaled.service" ];

    path = with pkgs; [ curl jq ];

    serviceConfig = {
      Type = "oneshot";
    };

    script = ''
      mkdir -p /var/lib/tailscale

      OAUTH_CLIENT_ID=$(cat ${config.age.secrets.tailscale-oauth-id.path})
      OAUTH_CLIENT_SECRET=$(cat ${config.age.secrets.tailscale-oauth-key.path})

      # get access token
      API_TOKEN=$(curl -sf -X POST https://api.tailscale.com/api/v2/oauth/token \
        -d "grant_type=client_credentials" \
        -d "client_id=$OAUTH_CLIENT_ID" \
        -d "client_secret=$OAUTH_CLIENT_SECRET" | jq --raw-output '.access_token')

      if [ -z "$API_TOKEN" ]; then
        echo "ERROR: Failed to obtain api token"
        exit 1
      fi


      # Generate auth key using the api token
      # "expirySeconds": 2419200 => 14 jours, le service se lance tout les 7 jours "normalement"
      AUTH_KEY=$(curl -sf -X POST "https://api.tailscale.com/api/v2/tailnet/-/keys" \
        -H "Authorization: Bearer $API_TOKEN" \
        -H "Content-Type: application/json" \
        -d '{
          "capabilities": {
            "devices": {
              "create": {
                "reusable": true,
                "ephemeral": false,
                "preauthorized": true,
                "tags": [
                  "tag:general"
                ]
              }
            }
          },
          "expirySeconds": 2419200
        }' | jq --raw-output '.key')

      if [ -z "$AUTH_KEY" ]; then
        echo "ERROR: Failed to generate auth key"
        exit 1
      fi

      # Write auth key to file
      printf '%s' "$AUTH_KEY" > /var/lib/tailscale/dynamic-authkey
      chmod 600 /var/lib/tailscale/dynamic-authkey
    '';
  };

  systemd.timers.generate-n-store-tailscale-auth-token = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "weekly";
      Persistent = true;
    };
  };
}
