{ config, pkgs, lib, ... }:

let
  feeds = {
    xkcd = "http://xkcd.com/atom.xml";
    dailywtf = "http://syndication.thedailywtf.com/TheDailyWtf";
    nixos = "https://weekly.nixos.org/feeds/all.rss.xml";
    rust = "https://blog.rust-lang.org/feed.xml";
    insiderust = "https://blog.rust-lang.org/inside-rust/feed.xml";
    kdb424 = "https://blog.kdb424.xyz/atom.xml";
    devto = "https://dev.to/feed/";
  };

  rss2emailConfig = {
    html-mail = "True";
    date-header = "True";
    from = "rss2email@home.localhost";
    force-from = "False";
    use-publisher-email = "True";
    active = "true";
    to = "willem@home.localhost";
    email-protocol = "maildir";
    maildir-mailbox = "feeds";
    maildir-path = config.home.sessionVariables.MAILDIR;
  };

  mkFeedString = name: url: ''

    [feed.${name}]
    url = ${url}
  '';

  configStrings = lib.mapAttrsToList (name: value: "${name} = ${value}\n") rss2emailConfig;

  feedStrings = lib.mapAttrsToList mkFeedString feeds;

  configArray = [ "[DEFAULT]\n" ] ++ configStrings ++ feedStrings;

  configString = lib.concatStrings configArray;
in
{
  home.packages = [ pkgs.rss2email ];

  home.file.".config/rss2email.cfg".text = configString;
}
