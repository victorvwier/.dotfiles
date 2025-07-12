{ config, pkgs, ... }:
{
  security.acme.acceptTerms = true;
  security.acme.defaults.email = "victorvwier@hotmail.com";
  services.nginx = {
    enable = true;

    # Use recommended settings
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    virtualHosts = let
      base = locations: {
        inherit locations;

        forceSSL = true;
        enableACME = true;
      };
      proxy = port: base {
        "/".proxyPass = "http://127.0.0.1:" + toString(port) + "/";
      };
    in {
      # Define victorvwier.nl as reverse-proxied service on port 8096
      "victorvwier.nl" = proxy 8096 // { default = true; };
    };
  };
}
