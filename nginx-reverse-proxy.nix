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

    # Only allow PFS-enabled ciphers with AES256
    # sslCiphers = "AES256+EECDH:AES256+EDH:!aNULL";
    
    # appendHttpConfig = ''
    #   # Add HSTS header with preloading to HTTPS requests.
    #   # Adding this header to HTTP requests is discouraged
    #   map $scheme $hsts_header {
    #       https   "max-age=31536000; includeSubdomains; preload";
    #   }
    #   add_header Strict-Transport-Security $hsts_header;

    #   # Enable CSP for your services.
    #   #add_header Content-Security-Policy "script-src 'self'; object-src 'none'; base-uri 'none';" always;

    #   # Minimize information leaked to other domains
    #   add_header 'Referrer-Policy' 'origin-when-cross-origin';

    #   # Disable embedding as a frame
    #   add_header X-Frame-Options DENY;

    #   # Prevent injection of code in other mime types (XSS Attacks)
    #   add_header X-Content-Type-Options nosniff;

    #   # This might create errors
    #   proxy_cookie_path / "/; secure; HttpOnly; SameSite=strict";
    # '';

    # Add any further config to match your needs, e.g.:
    virtualHosts = let
      base = locations: {
        inherit locations;

        forceSSL = true;
        enableACME = true;
      };
      proxy = port: base {
        "/".proxyPass = "https://127.0.0.1:" + toString(port) + "/";
      };
    in {
      # Define example.com as reverse-proxied service on 127.0.0.1:3000
      "victorvwier.nl" = proxy 8920 // { default = true; };
    };
  };
}
