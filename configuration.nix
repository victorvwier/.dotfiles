# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix

      # Home manager
      <home-manager/nixos> 
      
     # Jellyfin
     ./jellyfin/jellyfin.nix

     # Nginx reverse proxy (Master proxy)
     ./nginx-reverse-proxy.nix

     # Qbittorrent
     ./qbittorrent.nix 
     # VS Code Server Support
     (fetchTarball "https://github.com/nix-community/nixos-vscode-server/tarball/master")  
  ];
  
  # Set policy to allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "qbittorrent-nox-4.6.4"
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "stroomvretertje"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.victorvwier = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" "media"];
    packages = with pkgs; [
            
    ];
  };


  users.users.qbittorrent = {
    isNormalUser = true;
    extraGroups = [ "media" ];
  };

  # Home manager
  home-manager.users.victorvwier = { pkgs, ... }: {
    # Neovim
    programs.neovim = {
      enable = true;
      extraConfig = ''
    
      '';
    };



    # DO NOT CHANGE THS NUMBER
    home.stateVersion = "24.05";
  };

  # System packages
  environment.systemPackages = with pkgs; [
    git
    tmux
    btop
    python3
  ];

  services.qbittorrent = {
    enable = true;
    dataDir = "/var/lib/qbittorrent";
    port = 8090;
    openFirewall = true;
  };

  # VS Code Server
  services.vscode-server.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    ports = [ 22 ];
    settings = {
      PasswordAuthentication = true;
      AllowUsers = null;
    };
  };

  # Firewall configuration
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 80 443 22 ];
  networking.firewall.allowedUDPPorts = [ 1900 7359 ];

  # DO NOT CHANGE THIS NUMBER
  system.stateVersion = "24.05"; # Did you read the comment?

}

