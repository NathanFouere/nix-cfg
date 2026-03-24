# nix-cfg

Personal NixOS configuration managed with flakes. Heavily inspired by [Vimjoyer work](https://www.youtube.com/watch?v=a67Sv4Mbxmc).

## Installation

### Using an existing host configuration

1 - Clone the repository

2 - Remove the existing hardware configuration if you want to use an already defined host: 
```bash
rm -f hosts/<host>/hardware-configuration.nix
```

3 - Regenerate the hardware configuration if you want to use an already defined host: 
```bash
sudo nixos-generate-config --show-hardware-config > hosts/<host>/hardware-configuration.nix
```

4 - Switch to the new configuration: 
```bash
sudo nixos-rebuild switch --flake .#<host>
```

### Creating a new host configuration

1 - Clone the repository

2 - Do ur stuff

3 - Generate the hardware configuration: 
```bash
sudo nixos-generate-config --show-hardware-config > hosts/<host>/hardware-configuration.nix
```

4 - Switch to the new configuration: 
```bash 
sudo nixos-rebuild switch --flake .#<host>
```

## Update && Upgrade

```bash
nix flake update
sudo nixos-rebuild switch --flake .#<host>
```

## Ollama / Opencode

Connect to the host "tour" and run the following command to run opencode with ollama
```bash
ollama launch opencode
```

## Cloud-Hypervisor

To ping a running vm from the host:
```bash
sudo ch-remote --api-socket /var/lib/microvms/{{vm-name}}/{{vm-name}}.sock ping
```

## Get the K3S conf

```bash
source ./scripts/fetch-k3s-kubeconfig.sh
```

## K3S 

```mermaid
graph TD
    %% Définition des styles
    classDef external fill:#f9f,stroke:#333,stroke-width:2px;
    classDef cloudflare fill:#f38020,stroke:#333,stroke-width:2px,color:white;
    classDef home fill:#e1f5fe,stroke:#333,stroke-width:2px;
    classDef cluster fill:#fff9c4,stroke:#333,stroke-width:2px;
    classDef node fill:#e8f5e9,stroke:#333,stroke-width:1px;

    %% Noeuds
    User((Utilisateur Externe)):::external

    %% Groupe Cloudflare (La boite commune)
    subgraph CF_Zone [Cloudflare]
        CF_DNS[Cloudflare DNS]:::cloudflare
        CF_Tunnel[Cloudflare Tunnel]:::cloudflare
    end

    %% Groupe Réseau Maison
    subgraph Home_Network [Home Network]
        direction TB
        
        %% Cluster K3s
        subgraph K3S_Cluster [Cluster K3S]
            direction TB
            
            %% Ingress
            Traefik[Traefik Ingress Controller]:::cluster
            
            %% Applications
            subgraph Apps [Applications Déployées]
                App1[Application 1]:::cluster
                App2[Application 2]:::cluster
                App3[Application ...]:::cluster
            end

            %% Infrastructure Physique
            subgraph Infrastructure [Infrastructure Physique]
                direction LR
                subgraph TC1 [ThinkCentre 1]
                    N1[Noeud 1]:::node
                    N2[Noeud 2]:::node
                end
                subgraph TC2 [ThinkCentre 2]
                    N3[Noeud 3]:::node
                    N4[Noeud 4]:::node
                end
            end
        end
    end

    %% Flux de connexion (sans numérotation pour éviter l'erreur)
    User -->|Requête HTTPS| CF_DNS
    CF_DNS -->|Résolution| CF_Tunnel
    CF_Tunnel -->|Tunnel Sortant| Traefik
    
    %% Routage interne
    Traefik -->|Route| App1
    Traefik -->|Route| App2
    Traefik -->|Route| App3

    %% Lien logique applications -> infra
    Apps -.->|Hébergé sur| Infrastructure
```

## Sources

* https://www.youtube.com/watch?v=a67Sv4Mbxmc
* https://www.youtube.com/watch?v=vYc6IzKvAJQ
* https://github.com/Gabriella439/nixos-in-production
* https://www.youtube.com/watch?v=leR6m2plirs
* https://www.youtube.com/watch?v=2yplBzPCghA&t=134s
* https://www.joshuamlee.com/nixos-proxmox-vm-images/
* https://www.nijho.lt/post/proxmox-to-nixos/
* https://jrunestone.github.io/how-to-install-incus-lxd-on-nixos/
* https://microvm-nix.github.io/microvm.nix/
* https://determinate.systems/blog/nix-to-kubernetes/
* https://github.com/Gabriella439/nixos-in-production
* https://github.com/nix-community/nixos-anywhere
* https://paradigmatic.systems/posts/setting-up-deploy-rs/
* https://nlewo.github.io/nixos-manual-sphinx/index.html
* https://github.com/appleboy/ssh-action
* https://nix-tutorial.gitlabpages.inria.fr/nix-tutorial/index.html
* https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/networking/cluster/k3s/docs/USAGE.md
* https://docs.k3s.io/cli/token
* https://github.com/microvm-nix/microvm.nix/blob/main/doc/src/microvm-command.md
* https://microvm-nix.github.io/microvm.nix/simple-network.html
* https://markaicode.com/ubuntu-networking-comparison/
* https://www.cloudhypervisor.org/docs/prologue/commands/
* https://www.w3tutorials.net/blog/conditional-needs-in-github-actions/
* https://docs.k3s.io/cluster-access
* https://oneuptime.com/blog/post/2026-03-06-use-flux-operator-managing-flux-instances/view
* https://olai.dev/blog/nix-cloudflare-tunnels/
