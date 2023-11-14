{...}: {
  programs.ssh = {
    enable = true;

    forwardAgent = true;

    extraConfig = ''
      IgnoreUnknown UseKeychain
      AddKeysToAgent yes
      UseKeychain yes
      IdentityFile ~/.ssh/id_ed25519
    '';

    matchBlocks = {
      "zeus" = {
        hostname = "10.1.2.16";
        user = "willem";
      };
      "nixbox" = {
        hostname = "10.1.2.175";
        user = "willem";
      };
      "pizero" = {
        hostname = "10.1.2.171";
        user = "willem";
      };
      "thinkpad" = {
        hostname = "10.1.2.152";
        user = "willem";
      };
      "ubc" = {
        hostname = "remote.students.cs.ubc.ca";
        user = "willemml";
      };
      "*.students.cs.ubc.ca" = {
        user = "willemml";
      };
      "github.com" = {
        hostname = "ssh.github.com";
        port = 443;
      };
      "orlia-nas" = {
        hostname = "192.168.1.251";
        user = "willem";
      };
    };
  };
}
