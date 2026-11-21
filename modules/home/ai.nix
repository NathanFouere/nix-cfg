{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [ inputs.agenix.homeManagerModules.default ];

  config = {
    # ${XDG_RUNTIME_DIR} non développé par opencode/Claude Code
    age.secretsDir = "${config.home.homeDirectory}/.local/share/agenix";
    age.secrets = {
      opencode-github-token.file = ../../secrets/github-token.age;
      zotero-api-key.file = ../../secrets/zotero-api-key.age;
      zotero-library-id.file = ../../secrets/zotero-library-id.age;
    };

    programs.mcp = {
      enable = true;
      servers = {
        zotero = {
          command = "${pkgs.uv}/bin/uvx";
          args = [
            "--from"
            "zotero-mcp-server@0.17.3"
            "zotero-mcp"
          ];
          env = {
            ZOTERO_LOCAL = "false";
            ZOTERO_LIBRARY_TYPE = "user";
            ZOTERO_API_KEY.file = config.age.secrets.zotero-api-key.path;
            ZOTERO_LIBRARY_ID.file = config.age.secrets.zotero-library-id.path;
          };
        };

        github = {
          command = "${pkgs.github-mcp-server}/bin/github-mcp-server";
          args = [ "stdio" ];
          env.GITHUB_PERSONAL_ACCESS_TOKEN.file = config.age.secrets.opencode-github-token.path;
        };

        nixos.command = "${pkgs.mcp-nixos}/bin/mcp-nixos";

        context7.command = "${pkgs.context7-mcp}/bin/context7-mcp";
      };
    };

    programs.opencode = {
      enable = true;
      enableMcpIntegration = true;
    };

    programs.claude-code = {
      enable = true;
      enableMcpIntegration = true;
      # Claude Code modifie lui-même settings.json
      mutableSettings = true;
    };

    programs.opencode.agents = {
      studying = ''
        ---
        description: Tuteur pédagogique qui guide vers la compréhension sans donner de réponses directes.
        mode: primary
        ---

        Tu es un tuteur pédagogique. Ton rôle est de guider l'utilisateur vers
        la compréhension, NON de lui donner des réponses directes.

        ## Règles strictes
        - NE JAMAIS donner la solution finale ou le code complet
        - NE JAMAIS écrire le code à la place de l'utilisateur
        - Toujours répondre dans la langue de l'utilisateur

        ## Approche pédagogique
        1. Identifie la notion/clé que l'utilisateur doit comprendre
        2. Explique le concept avec tes propres mots (court)
        3. Fournis des liens vers la documentation officielle pertinente
        4. Pose des questions-guides pour amener l'utilisateur à trouver la réponse lui-même
        5. Donne des indices progressifs si l'utilisateur bloque

        ## Format de réponse
        - **Notion clé** : brève explication du concept
        - **Documentation** : liens officiels (mdn, nixos wiki, docs officielles, man pages)
        - **Question guide** : une question qui fait avancer la réflexion
        - **Indice** (si demandé) : un indice ciblé, pas la solution

        ## Quand l'utilisateur se trompe
        - Ne corrige pas directement
        - Souligne la partie incorrecte et demande pourquoi
        - Renvoie vers la doc qui contient la réponse

        N'oublie jamais : l'objectif est l'autonomie de l'utilisateur.
      '';
    };
  };
}
