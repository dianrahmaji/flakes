{
  description = "dianrahmaji's nix system configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs: {
    darwinConfigurations.macbookpro = inputs.darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      pkgs = import inputs.nixpkgs { 
        system = "aarch64-darwin";
        config.allowUnfree = true;
      };
      modules = [
        ({ pkgs, ... }: {
          programs.zsh.enable = true;
          environment.shells = with pkgs; [
            bash
            zsh
          ];
          environment.systemPackages = with pkgs; [
            mkalias
          ];
          nix.extraOptions = ''
            experimental-features = nix-command flakes
          '';
          system.stateVersion = 5;
          users.users.dianrahmaji = {
            home = "/Users/dianrahmaji/";
          };
        })
        inputs.home-manager.darwinModules.home-manager {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.dianrahmaji.imports = [
              ({ pkgs, ... }:
                let 
                  # FIXME: manage secret purely
                  secretsPath = builtins.getEnv "SECRETS";
                  secrets = import (builtins.toPath secretsPath);
                in {
                home.stateVersion = "24.05";
                home.packages = with pkgs; [
                  awscli
                  aws-vault
                  discord
                  firefox
                  spotify
                  vscode
                  zoom-us
                ];
                programs.bat.enable = true;
                programs.eza.enable = true;
                programs.fzf = {
                  enable = true;
                  enableZshIntegration = true;
                };
                programs.git = {
                  enable = true;
                  userName = "Dian Rahmaji";
                  userEmail = secrets.personalEmail;
                  aliases = {
                    ba = "branch --all";
                    cb = "checkout -b";
                    cf = "commit --fixup";
                    ca = "commit --all --message";
                    cm = "commit --message";
                    co = "checkout";
                    cx = "commit --amend";
                    ll = "log --oneline";
                    ri = "rebase --interactive";
                    po = "push origin";
                    pof = "push origin --force";
                    ria = "rebase --interactive --autosquash";
                    rrm = "rebase --rebase-merges";
                  };
                  extraConfig = {
                    core = {
                      sshCommand = "ssh -i ${secrets.personalSshKey}";
                      editor = "vim";
                    };
                    init = {
                      defaultBranch = "main";
                    };
                  };
                  includes = [
                    {
                      contents = {
                        user.email = secrets.jakmallEmail;
                        core.sshCommand = "ssh -i ${secrets.jakmallSshKey}";
                      };
                      condition = "gitdir:~/workspaces/";
                    }
                  ];
                };
                programs.neovim = {
                  enable = true;
                  viAlias = true;
                  vimAlias = true;
                  vimdiffAlias = true;
                };
                programs.ripgrep.enable = true;
                programs.starship.enable = true;
                programs.zoxide = {
                  enable = true;
                  options = ["--cmd cd"];
                };
              })
            ];
          };
        }
      ];
    };
  };
}
