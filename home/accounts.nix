{ config, pkgs, inputs, ... }:

let
  passCmd = path: "${pkgs.pass}/bin/pass ${path}";
  gmailAccount = address: {
    inherit address;
    flavor = "gmail.com";
    folders = {
      drafts = "[Gmail].Drafts";
      inbox = "INBOX";
      sent = "[Gmail].Sent Mail";
      trash = "[Gmail].Trash";
    };
    mu.enable = true;
    offlineimap.enable = true;
    passwordCommand = passCmd "gmail/${address}";
    imap.tls = {
      enable = true;
      useStartTls = true;
    };
    smtp.tls = {
      enable = true;
      useStartTls = true;
    };
  };
in
{
  accounts.email.accounts = {
    gmail = gmailAccount "willemleitso@gmail.com";
    leitso = (gmailAccount "willem@leit.so") // { primary = true; };
    wnuke9 = gmailAccount "wnuke9@gmail.com";
  };
}
  
