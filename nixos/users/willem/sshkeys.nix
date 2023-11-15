{globals, ...}: {
  users.users.willem = {
    openssh.authorizedKeys.keyFiles = globals.sshAuthorizedKeyFiles;
  };
}
