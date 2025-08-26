{ pkgs, ... }: {
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
  users.knownUsers = [ "dianrahmaji" ];
  users.users.dianrahmaji = {
    home = "/Users/dianrahmaji";
    uid = 501;
  };
}
