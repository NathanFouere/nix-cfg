{
  config = {
    ## TODO => vérifier si besoin sur toutes les machines ou que le server
    networking.firewall = {
      enable = true;
      # cf . https://github.com/rorosen/k3s-nix <3
      checkReversePath = false;
      allowedTCPPorts = [
        22 # SSH
        6443 # k3s: required so that pods can reach the API server (running on port 6443 by default)
        443
        30000 # Traefik
      ];
      allowedUDPPorts = [
        8472 # k3s, flannel: required if using multi-node for inter-node networking
      ];
      trustedInterfaces = [ "cni+" "flannel.1" ];
    };
  };
}
