{ pkgs, config, lib, ... }: {
  home.username = "dianrahmaji";
  home.stateVersion = "24.05";
  home.packages = with pkgs; [
    awscli
    aws-vault
    discord
    firefox
    mkalias
    spotify
    vscode
    zoom-us
  ];
  home.activation = {
    copyApplications = let
      apps = pkgs.buildEnv {
        name = "home-manager-applications";
        paths = config.home.packages;
        pathsToLink = "/Applications";
      };
   in
      pkgs.lib.mkForce ''
        # Set up applications.
        echo "setting up /Applications..." >&2
        rm -rf /Applications/Nix\ Apps
        mkdir -p /Applications/Nix\ Apps
        find ${apps}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
        while read -r src; do
          app_name=$(basename "$src")
          echo "copying $src" >&2
          ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
        done
      '';
  };
  programs.bat.enable = true;
  programs.eza.enable = true;
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
  programs.git = {
    enable = true;
    userName = "Dian Rahmaji";
    userEmail = "dianrahmaji@gmail.com";
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
        sshCommand = "ssh -i ~/.ssh/id_ed25519_personal";
        editor = "vim";
      };
      init = {
        defaultBranch = "main";
      };
    };
    includes = [
      {
        contents = {
          user.email = "dianrahmaji.jakmall@gmail.com";
          core.sshCommand = "ssh -i ~/.ssh/id_ed25519_jakmall";
        };
        condition = "gitdir:~/workspaces/";
      }
    ];
  };
  programs.home-manager.enable = true;
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
  };
  programs.ripgrep.enable = true;
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };
  programs.zoxide = {
    enable = true;
    options = ["--cmd cd"];
    enableZshIntegration = true;
  };
  programs.zsh.enable = true;
}
