{ config, pkgs, ... }:

let
  passCmd = address: "${pkgs.python310Packages.keyring}/bin/keyring get login email(${address})";
  generalAccount = address: {
    inherit address;
    userName = address;
    mu.enable = true;
    offlineimap.enable = true;
    imap.tls = {
      enable = true;
      useStartTls = true;
    };
    smtp.tls = {
      enable = true;
      useStartTls = true;
    };
    passwordCommand = passCmd address;
  };

  gmailAccount = address: ({
    flavor = "gmail.com";
    folders = {
      drafts = "[Gmail].Drafts";
      inbox = "INBOX";
      sent = "[Gmail].Sent Mail";
      trash = "[Gmail].Trash";
    };
  } // generalAccount address);
in
{
  accounts.email.accounts = {
    gmail = (gmailAccount "willemleitso@gmail.com") // { realName = "Willem Leitso"; };
    icloud = (pkgs.lib.attrsets.recursiveUpdate {
      flavor = "plain";
      imap.host = "imap.mail.me.com";
      imap.port = 993;
      smtp.host = "smtp.mail.me.com";
      smtp.port = 587;
    } (generalAccount "coalminecraft@icloud.com")) // { folders.inbox = "INBOX"; };
    leitso = (gmailAccount "willem@leit.so") // { primary = true; realName = "Willem Leitso"; };
    wnuke9 = gmailAccount "wnuke9@gmail.com";
  };
}
  
