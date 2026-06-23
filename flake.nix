{
  description = "LHZSH zsh configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";

    zsh-completions = {
      url = "github:zsh-users/zsh-completions";
      flake = false;
    };

    zsh-history-substring-search = {
      url = "github:zsh-users/zsh-history-substring-search";
      flake = false;
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      flake-parts,
      zsh-completions,
      zsh-history-substring-search,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      perSystem =
        {
          lib,
          pkgs,
          system,
          ...
        }:
        let
          lhzsh = pkgs.stdenvNoCC.mkDerivation {
            pname = "lhzsh";
            version = "0.1.0";
            src = self;

            nativeBuildInputs = [ pkgs.makeWrapper ];

            installPhase = ''
              runHook preInstall

              install -Dm755 bin/lhzsh "$out/bin/lhzsh"
              install -Dm644 config "$out/share/lhzsh/config"
              install -Dm644 alias.zsh "$out/share/lhzsh/alias.zsh"
              install -Dm644 theme.zsh "$out/share/lhzsh/theme.zsh"
              install -Dm644 fixenv.zsh "$out/share/lhzsh/fixenv.zsh"
              install -Dm644 fastfetch.jsonc "$out/share/lhzsh/fastfetch.jsonc"

              mkdir -p "$out/share/lhzsh/bin" "$out/share/lhzsh/plugins"
              ln -s "$out/bin/lhzsh" "$out/share/lhzsh/bin/lhzsh"
              ln -s ${zsh-completions} "$out/share/lhzsh/plugins/zsh-completions"
              ln -s ${zsh-history-substring-search} "$out/share/lhzsh/plugins/zsh-history-substring-search"

              cp -R eza-config "$out/share/lhzsh/eza-config"

              wrapProgram "$out/bin/lhzsh" \
                --set LHZSH_SOURCE "$out/share/lhzsh/config" \
                --prefix PATH : ${
                  lib.makeBinPath [
                    pkgs.coreutils
                    pkgs.git
                    pkgs.gnused
                    pkgs.zsh
                  ]
                }

              runHook postInstall
            '';

            meta = {
              description = "Opinionated zsh configuration with prompt, aliases, and bundled plugins";
              homepage = "https://github.com/AWildLeon/lhzsh";
              platforms = [
                "x86_64-linux"
                "aarch64-linux"
                "x86_64-darwin"
                "aarch64-darwin"
              ];
            };
          };
        in
        {
          packages = {
            inherit lhzsh;
            default = lhzsh;
          };

          apps = {
            lhzsh = {
              type = "app";
              program = "${lhzsh}/bin/lhzsh";
            };
            default = self.apps.${system}.lhzsh;
          };
        };

      flake = {
        overlays.default = final: prev: {
          lhzsh = self.packages.${final.system}.lhzsh;
        };

        nixosModules.default =
          {
            config,
            lib,
            pkgs,
            ...
          }:
          let
            cfg = config.programs.lhzsh;
            package = cfg.package;
          in
          {
            options.programs.lhzsh = {
              enable = lib.mkEnableOption "LHZSH zsh configuration";
              package = lib.mkOption {
                type = lib.types.package;
                default = self.packages.${pkgs.system}.lhzsh;
                defaultText = lib.literalExpression "inputs.lhzsh.packages.${pkgs.system}.lhzsh";
                description = "LHZSH package to install and source for interactive zsh shells.";
              };
              dataDir = lib.mkOption {
                type = lib.types.nullOr lib.types.str;
                default = null;
                description = "Writable directory for LHZSH state. If null, LHZSH chooses a per-user default at shell startup.";
              };
            };

            config = lib.mkIf cfg.enable {
              environment.systemPackages = [ package ];

              # Keep zsh registered as a system shell, but disable every bit of
              # NixOS's own zsh management so it contributes nothing to the
              # interactive config. LHZSH is fully self-contained (history,
              # compinit, completion, prompt, keybindings, aliases) and is the
              # single source of truth. With all the managed sections emptied,
              # nothing follows our interactiveShellInit to override LHZSH.
              programs.zsh = {
                enable = true;
                enableGlobalCompInit = lib.mkForce false;
                enableCompletion = lib.mkForce false;
                enableBashCompletion = lib.mkForce false;
                enableLsColors = lib.mkForce false;
                syntaxHighlighting.enable = lib.mkForce false;
                autosuggestions.enable = lib.mkForce false;
                promptInit = lib.mkForce "";
                setOptions = lib.mkForce [ ];
                shellAliases = lib.mkForce { };
                interactiveShellInit = lib.mkAfter ''
                  ${lib.optionalString (
                    cfg.dataDir != null
                  ) "export LHZSH_DATA_DIR=${lib.escapeShellArg cfg.dataDir}"}
                  source ${package}/share/lhzsh/config
                '';
              };
            };
          };

        homeManagerModules.default =
          {
            config,
            lib,
            pkgs,
            ...
          }:
          let
            cfg = config.programs.lhzsh;
            package = cfg.package;
          in
          {
            options.programs.lhzsh = {
              enable = lib.mkEnableOption "LHZSH zsh configuration";
              package = lib.mkOption {
                type = lib.types.package;
                default = self.packages.${pkgs.system}.lhzsh;
                defaultText = lib.literalExpression "inputs.lhzsh.packages.${pkgs.system}.lhzsh";
                description = "LHZSH package to install and source for interactive zsh shells.";
              };
              dataDir = lib.mkOption {
                type = lib.types.str;
                default = "${config.xdg.dataHome}/lhzsh";
                description = "Writable directory for LHZSH state.";
              };
            };

            config = lib.mkIf cfg.enable {
              home.packages = [ package ];
              programs.fastfetch.enable = true;
              programs.zsh.enable = true;
              programs.zsh.initContent = lib.mkAfter ''
                export LHZSH_DATA_DIR=${lib.escapeShellArg cfg.dataDir}
                source ${package}/share/lhzsh/config
              '';
            };
          };
      };
    };
}
