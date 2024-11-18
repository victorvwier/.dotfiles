{ config, pkgs, ... }:
{
  # Dependencies
  environment.systemPackages = [
    pkgs.jellyfin
    pkgs.jellyfin-web
    pkgs.jellyfin-ffmpeg
  ];

  # Jellyfin
  services.jellyfin = {
    enable = true;
    openFirewall = true;
    dataDir = "/mnt/HDD/jellyfin/";
    user = "victorvwier";
  }; 
}