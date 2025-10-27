{ ... }:
{
  programs.ssh = {
    enable = true;

    matchBlocks = {
      github = {
        host = "github.com";
        hostname = "ssh.github.com";
        user = "git";
        port = 443;
        identityFile = "~/.ssh/id_github";
        identitiesOnly = true;
      };
      spider = {
        host = "10.1.10.1*";
        user = "localadmin";
        port = 22;
        identityFile = "~/.ssh/id_ed25519";
        identitiesOnly = true;
        extraOptions = {
          SetEnv = "TERM=xterm-256color";
        };
      };
    };
  };

  services.ssh-agent.enable = true;
}
