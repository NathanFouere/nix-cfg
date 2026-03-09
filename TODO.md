## TODO

- [x] Mettre en place micro-vm
  - [x] Setup deux vm par think-center
- [ ] Créer vm pour modele IA locaux sur tour
  - [ ] Tester acces depuis laptop du modele tournant sur la tour
- [ ] Mettre en place cluster kubernetes (1 vm master, 3 vm worker)
  - [ ] lancer systeme k3s
  - [ ] créer diskimage pour les vm (voir https://github.com/nix-community/disko/blob/master/docs/disko-images.md)
  - [ ] faire communiquer un server et un agent sur une vm
  - [ ] fiare communiquer 2 agents d'une vm avec server de l'autre
- [ ] Utiliser une machine / vm comme noeud d'entrée au réseau local afin d'enlever la dépendance à taiscale sur chaque machine
- [ ] Créer machine qui build les configs et utiliser cacher grâce à hydra (https://github.com/NixOS/hydra)
- [ ] Regener automatiquement la clé pour tailscale tous les mois
- [ ] setup grafana pour monitorer les machines
