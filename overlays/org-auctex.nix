{ pkgs }:

pkgs.emacsPackages.trivialBuild {
  pname = "org-auctex";
  version = "e1271557b9f36ca94cabcbac816748e7d0dc989c";

  src = pkgs.fetchFromGitHub {
    owner = "karthink";
    repo = "org-auctex";
    rev = "e1271557b9f36ca94cabcbac816748e7d0dc989c";
    sha256 = "sha256-cMAhwybnq5HA1wOaUqDPML3nnh5m1iwEETTPWqPbAvw=";
  };
}
