{
  programs.ssh = {
    matchBlocks = {
      github = {
        hostname = "*.github.com";
        identityFile = "~/.ssh/id_ed25519";
      };
    };

    matchBlocks = {
      linode = {
        hostname = "server.cuichen.cc";
        identityFile = "~/.ssh/id_ed25519";
      };
    };
  };
}
