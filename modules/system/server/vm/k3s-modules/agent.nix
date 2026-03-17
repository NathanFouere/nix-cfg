{ serverAddr }:
{
  config = {

    networking.firewall.allowedTCPPorts = [
      22 # SSH
    ];

    services.k3s = {
      enable = true;
      role = "agent";
      tokenFile = "/run/agenix/k3s-token";
      inherit serverAddr;
      extraFlags = toString [
        "--debug" # Optionally add additional args to k3s
      ];
    };
  };
}
