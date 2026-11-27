# AGENTS.md

Personal NixOS configuration (flakes + home-manager). Comments in code are in English; talk to the user in French.

## Layout

- `flake.nix` — inputs, one `nixosConfigurations.<host>` per machine, deploy-rs nodes (`thinkcentre-1`, `thinkcentre-2`, `raspberry-pi3-1`).
- `hosts/<host>/configuration.nix` — host entry point: lists the system modules it imports, users, host-specific values. `hardware-configuration.nix` is generated, don't edit it.
- `modules/system/common/` — shared by every host (desktops and servers).
- `modules/system/normal/` — desktop/laptop only (`prog.nix` = dev tools, `niri.nix`, `stylix.nix`, …).
- `modules/system/server/` — servers (k3s, zfs, nfs, monitoring, bastion).
- `home/home-perso.nix`, `home/home-server.nix` — home-manager entry points, they import `modules/home/*.nix`.
- `modules/home/` — user-level config (niri, noctalia, zed, ghostty, …).
- `secrets/*.age` — agenix secrets, never decrypt or print them.

## Guidelines

- Keep it simple: plain config, copy the pattern already used in the repo (grep first). No helper functions or abstractions.
- Put a change in the module where it belongs instead of creating a new one; a new module must be added to the `imports` of the hosts (or `home/*.nix`) that need it.
- System packages go in `environment.systemPackages = with pkgs; [ … ];` of the relevant module, user packages in `home.packages`.
- Secrets: agenix, used inline as `$(cat ${config.age.secrets.<name>.path})` in a small `writeShellScript` (see `modules/system/common/tailscale.nix`).
- Check option names against the pinned version (nixos MCP, or the flake input's source) — don't guess.
- Add a short comment with a link when an option comes from upstream docs, like the existing modules do.
- Never commit, `nixos-rebuild switch` or deploy unless asked.

## Validate a change

1. Evaluate (no build — builds are long, don't run `nix build`):

   ```sh
   nix eval .#nixosConfigurations.<host>.config.system.build.toplevel.drvPath
   ```

   Use the host(s) that import the changed module (`hostname` for the current machine). New files must be `git add`-ed, flakes ignore untracked files.

2. Lint / format — same tool as CI (`.github/workflows/ci-cd.yml`), `nixfmt`:

   ```sh
   nixfmt -c path/to/changed.nix   # check
   nixfmt path/to/changed.nix      # fix
   ```

   Only format the files you touched (a few files are not formatted yet, leave them alone).

3. CI also runs `nix flake check`; run it when touching `flake.nix`.

## Look at the screen

For visual issues (theme, colors, unreadable text, monitor layout, bar…), take a screenshot with `grim` (installed by `modules/home/screenshot.nix`) and read the image instead of guessing:

```sh
mkdir -p /tmp/shots
grim /tmp/shots/all.png               # every monitor
grim -o eDP-1 /tmp/shots/laptop.png   # a single output (names: `niri msg outputs`)
```

The full capture is large: shrink or crop it before reading (`nix-shell -p imagemagick --run 'magick in.png -resize 1800x out.png'`, or `-crop WxH+X+Y` to zoom). Screenshots can show private content: keep them in `/tmp`, never commit or send them anywhere.

## Apply (only when the user asks)

```sh
sudo nixos-rebuild switch --flake .#<host>                                # local machine
nix run github:serokell/deploy-rs -- .                                    # all servers
nix run github:serokell/deploy-rs -- --targets .#thinkcentre-1 .#thinkcentre-2
```

The Raspberry Pi is aarch64: add `--remote-build` if the local machine can't build for it.
