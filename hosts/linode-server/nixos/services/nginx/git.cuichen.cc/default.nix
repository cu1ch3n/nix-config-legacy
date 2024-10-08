{ config, lib, pkgs, ... }:

let
  cgitPkg = pkgs.cgit-default-theme;
  configFile = pkgs.writeText "cgitrc" (import ./cgitrc.nix cgitPkg);
in
{
  environment.systemPackages = [ cgitPkg ];

  services.nginx.virtualHosts = {
    "git.cuichen.cc" = {
      forceSSL = true;
      enableACME = true;
      root = "${cgitPkg}/cgit/";

      extraConfig = ''
        try_files  $uri @cgit;
      '';

      locations = {
        "~ /.+/(info/refs|git-upload-pack)" = {
          fastcgiParams = {
            SCRIPT_FILENAME = "${pkgs.git}/bin/git-http-backend";
            PATH_INFO = "$uri";
            GIT_HTTP_EXPORT_ALL = "1";
            GIT_PROJECT_ROOT = "/var/git";
            HOME = "/var/git";
          };
          extraConfig = ''
            include       ${pkgs.nginx}/conf/fastcgi_params;
            fastcgi_pass  unix:${config.services.fcgiwrap.socketAddress};
          '';
        };
        "@cgit" = {
          fastcgiParams = {
            CGIT_CONFIG = configFile;
            SCRIPT_FILENAME = "${cgitPkg}/cgit/cgit.cgi";
            PATH_INFO = "$uri";
            QUERY_STRING = "$args";
            HTTP_HOST = "$server_name";
          };
          extraConfig = ''
            include       ${pkgs.nginx}/conf/fastcgi_params;
            fastcgi_pass  unix:${config.services.fcgiwrap.socketAddress};
          '';
        };
      };
    };
  };
}
