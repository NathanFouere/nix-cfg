{ serverAddr }:
{
  config = {
    networking.firewall = {
      enable = true;
      # cf . https://github.com/rorosen/k3s-nix <3
      checkReversePath = false;
      allowedTCPPorts = [
        22 # SSH
        30000 # Traefik
      ];
      allowedUDPPorts = [
        8472 # k3s, flannel: required if using multi-node for inter-node networking
      ];
      trustedInterfaces = [
        "cni+"
        "flannel.1"
      ];
    };

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
