{
  config,
  pkgs,
  lib,
  ...
}: let
  feeds = {
    calvinandhobbes = "https://www.comicsrss.com/rss/calvinandhobbes.rss";
    dailywtf = "http://syndication.thedailywtf.com/TheDailyWtf";
    devto = "https://dev.to/feed/";
    insiderust = "https://blog.rust-lang.org/inside-rust/feed.xml";
    kdb424 = "https://blog.kdb424.xyz/atom.xml";
    logrocket = "https://blog.logrocket.com/feed/";
    nixos = "https://weekly.nixos.org/feeds/all.rss.xml";
    rust = "https://blog.rust-lang.org/feed.xml";
    sourcehut = "https://sourcehut.org/blog/index.xml";
    xkcd = "http://xkcd.com/atom.xml";
  };

  rss2emailConfig = {
    active = "true";
    date-header = "True";
    email-protocol = "maildir";
    force-from = "False";
    from = "rss2email@home.localhost";
    html-mail = "True";
    maildir-mailbox = "feeds";
    maildir-path = config.home.sessionVariables.MAILDIR;
    to = "willem@home.localhost";
    use-publisher-email = "True";
  };

  mkFeedString = name: url: ''

    [feed.${name}]
    url = ${url}
  '';

  configStrings = lib.mapAttrsToList (name: value: "${name} = ${value}\n") rss2emailConfig;

  feedStrings = lib.mapAttrsToList mkFeedString feeds;

  configArray = ["[DEFAULT]\n"] ++ configStrings ++ feedStrings;

  configString = lib.concatStrings configArray;
in {
  home.packages = [pkgs.rss2email];

  home.file.".config/rss2email.cfg".text = configString;
}
